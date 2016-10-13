//
//  CSWebShot.h
//  CSWebShot
//
//  Created by Cătălin Stan on 13/10/2016.
//  Copyright © 2016 Cătălin Stan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for CSWebShot.
FOUNDATION_EXPORT double CSWebShotVersionNumber;

//! Project version string for CSWebShot.
FOUNDATION_EXPORT const unsigned char CSWebShotVersionString[];

#define CSWebShotErrorDomain           @"CSWebShotErrorDomain"
#define CSWebShotErrorInvalidURL       101
#define CSWebShotErrorNoData           102

typedef NS_ENUM(NSInteger, WSAction) {
    WSActionNone,
    WSActionWebShot,
    WSActionFetchHTML
};

typedef void(^WSCompletionBlock)(WSAction action, NSData * _Nullable data, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface CSWebShot : NSObject

@property (nonatomic, strong, nullable) NSURL * URL;

@property (nonatomic) NSTimeInterval renderingTimeout;

@property (nonatomic) CGFloat browserWidth;

@property (nonatomic, strong) dispatch_queue_t delegateQueue;

- (nonnull instancetype)initWithURL:(NSURL * _Nullable)URL NS_DESIGNATED_INITIALIZER;

- (void)webshotWithCompletion:(WSCompletionBlock)completion;
- (void)renderedHTMLWithCompletion:(WSCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
