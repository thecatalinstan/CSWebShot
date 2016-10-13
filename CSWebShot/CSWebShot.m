//
//  CSWebShot.m
//  CSWebShot
//
//  Created by Cătălin Stan on 13/10/2016.
//  Copyright © 2016 Cătălin Stan. All rights reserved.
//

#import <WebKit/WebKit.h>

#import "CSWebShot.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSWebShot () <WebFrameLoadDelegate, WebDownloadDelegate>

@property (strong, nonatomic) NSWindow * window;

@property (strong, nonatomic) WebView *webView;
@property (nonatomic) WSAction action;

- (void)performAction;

@end

NS_ASSUME_NONNULL_END

@implementation CSWebShot

- (instancetype)init {
    return [self initWithURL:[NSURL URLWithString:@""] completion:nil];
}

- (instancetype)initWithURL:(NSURL *)URL {
    return [self initWithURL:URL completion:nil];
}

- (instancetype)initWithURL:(NSURL *)URL completion:(WSCompletionBlock)completion {
    self = [super init];
    if ( self != nil ) {
        self.URL = URL;
        self.completion = completion;

        self.delegateQueue = dispatch_get_main_queue();
    }
    return self;
}

#pragma mark - Actions

- (void)webshot {
    return [self webshotWithCompletion:nil];
}

- (void)webshotWithCompletion:(WSCompletionBlock)completion {
    if ( completion ) {
        self.completion = completion;
    }

    self.action = WSActionWebShot;
    [self performAction];
}

- (void)renderedHTML {
    return [self renderedHTMLWithCompletion:nil];
}

- (void)renderedHTMLWithCompletion:(WSCompletionBlock)completion {
    if ( completion ) {
        self.completion = completion;
    }

    self.action = WSActionFetchHTML;
    [self performAction];
}

- (void)performAction {
    if ( self.URL.absoluteString.length == 0 || !([self.URL.absoluteString hasPrefix:@"http://"] || [self.URL.absoluteString hasPrefix:@"https://"]) ) {

        WSAction action = self.action;
        WSCompletionBlock __weak completion = self.completion;
        dispatch_queue_t __weak delegateQueue = self.delegateQueue;

        NSError* error = [NSError errorWithDomain:CSWebShotErrorDomain code:CSWebShotErrorInvalidURL userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"An invalid URL was provided.",), NSURLErrorFailingURLErrorKey: self.URL ? : @"(null)" }];

        dispatch_async(delegateQueue, ^{ @autoreleasepool {
            completion(action, nil, error);
        }});
        
        return;
    }
    dispatch_barrier_async(dispatch_get_main_queue(), ^{ @autoreleasepool {
        self.webView = [[WebView alloc] initWithFrame:NSMakeRect(0, 0, 1280, 10)];
        self.webView.frameLoadDelegate = self;
        self.webView.downloadDelegate = self;
        self.webView.continuousSpellCheckingEnabled = NO;
        self.webView.mainFrame.frameView.allowsScrolling = NO;

        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:self.URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0f];
        request.HTTPShouldHandleCookies = NO;

        [self.webView.mainFrame loadRequest:request];
    }});
}

#pragma mark - WebViewFeameLoading Delegate

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
    if (frame != sender.mainFrame) {
        return;
    }

    WSAction action = self.action;
    WSCompletionBlock __weak completion = self.completion;
    dispatch_queue_t __weak delegateQueue = self.delegateQueue;

    dispatch_barrier_async(dispatch_get_main_queue(), ^{ @autoreleasepool {
        NSData* returnData;

        if ( action == WSActionFetchHTML ) {
            NSString* renderedContent = ((DOMHTMLElement*)frame.DOMDocument.documentElement).outerHTML;
            returnData = [renderedContent dataUsingEncoding:NSUTF8StringEncoding];
        } else if ( action == WSActionWebShot ) {
            NSView *webFrameViewDocView = frame.frameView.documentView;
            NSRect webFrameRect = webFrameViewDocView.frame;
            NSRect newWebViewRect = NSMakeRect(0, 0, NSWidth(webFrameRect), NSHeight(webFrameRect) == 0 ? frame.webView.fittingSize.height : NSHeight(webFrameRect));

            NSRect cacheRect = newWebViewRect;
            NSSize imgSize = cacheRect.size;
            NSRect srcRect = NSZeroRect;
            srcRect.size = imgSize;
            srcRect.origin.y = cacheRect.size.height - imgSize.height;

            NSRect destRect = NSZeroRect;
            destRect.size = imgSize;

            NSBitmapImageRep *bitmapRep = [webFrameViewDocView bitmapImageRepForCachingDisplayInRect:cacheRect];
            [webFrameViewDocView cacheDisplayInRect:cacheRect toBitmapImageRep:bitmapRep];

            NSImage *image = [[NSImage alloc] initWithSize:imgSize];
            [image lockFocus];
            [bitmapRep drawInRect:destRect fromRect:srcRect operation:NSCompositeCopy fraction:1.0 respectFlipped:YES hints:nil];
            [image unlockFocus];

            NSBitmapImageRep* rep = [[NSBitmapImageRep alloc] initWithData:image.TIFFRepresentation];;
            returnData = [rep representationUsingType:NSPNGFileType properties:@{}];
        }

        dispatch_async(delegateQueue, ^{ @autoreleasepool {
            completion(action, returnData, nil);
        }});
    }});
}

//- (void)webView:(WebView *)sender willPerformClientRedirectToURL:(NSURL *)URL delay:(NSTimeInterval)seconds fireDate:(NSDate *)date forFrame:(WebFrame *)frame {
//}

//- (void)webView:(WebView *)sender didReceiveServerRedirectForProvisionalLoadForFrame:(WebFrame *)frame {
//}

//- (void)webView:(WebView *)sender didCommitLoadForFrame:(WebFrame *)frame {
//}

- (void)webView:(WebView *)sender didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame {
    if (frame != sender.mainFrame){
        return;
    }

    WSAction action = self.action;
    WSCompletionBlock __weak completion = self.completion;
    dispatch_queue_t __weak delegateQueue = self.delegateQueue;

    dispatch_async(delegateQueue, ^{ @autoreleasepool {
        completion(action, nil, error);
    }});
}


@end
