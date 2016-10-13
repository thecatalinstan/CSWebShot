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

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WSAction) {
    WSActionNone,
    WSActionWebShot,
    WSActionFetchHTML
};

typedef void(^WSCompletionBlock)(WSAction action, NSData * _Nullable data, NSError * _Nullable error);

@interface CSWebShot : NSObject

@property (nonatomic, strong) NSURL * URL;
@property (nonatomic, copy, nullable) WSCompletionBlock completion;
@property (nonatomic, strong) dispatch_queue_t delegateQueue;

- (instancetype)initWithURL:(NSURL *)URL;
- (instancetype)initWithURL:(NSURL *)URL completion:(WSCompletionBlock _Nullable)completion NS_DESIGNATED_INITIALIZER;

- (void)webshot;
- (void)webshotWithCompletion:(WSCompletionBlock _Nullable)completion;

- (void)renderedHTML;
- (void)renderedHTMLWithCompletion:(WSCompletionBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
