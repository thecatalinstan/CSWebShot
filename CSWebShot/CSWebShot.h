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

/**
 *  The types of actions that can be performed by WebShot
 */
typedef NS_ENUM(NSInteger, WSAction) {

    /**
     *  No action will be performed.
     */
    WSActionNone,

    /**
     *  Obtain a rendering of the webpage as a PNG image.
     */
    WSActionWebShot,

    /**
     *  Obtain the fully rendered HTML content of the webpage.
     */
    WSActionFetchHTML
};

/**
 *  The block that is invoked after the WebShot action has been performed
 *
 *  @param action   The `WSAction` that was performed.
 *  @param data     The data that was fetched or `nil` if an error has occured.
 *  @param error    Action errors are returned in this parameter.
 *
 *  @discussion
 *  The `data` parameter can either contain PNG data or plain text, depending on
 *  the requested action. If an error has occured, this parameter is `nil` and 
 *  the error parameter will contain the appropriate error object.
 */
typedef void(^WSCompletionBlock)(WSAction action, NSData * _Nullable data, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

/**
 *  The `CSWebShot` class provides an easy way to obtain the fully rendered
 *  content of a web-page, as the browser *sees* it, after all JavaScript, CSS
 *  and images have loaded and executed, either as a PNG or HTML text.
 */
@interface CSWebShot : NSObject

/**
 *  The URL to be fetched.
 */
@property (nonatomic, strong, nullable) NSURL * URL;

/**
 *  @name Controlling what is rendered
 */

/**
 *  The amount of time to wait, after the page and all it's assets have loaded,
 *  before generating the snapshot.
 */
@property (nonatomic) NSTimeInterval renderingTimeout;

/**
 *  The width, in pixels, of the browser window that will be used to render the 
 *  page. This is usefull only when requesting PNG screenshots. *Defaults to
 *  1280px*.
 *
 *  @discussion
 *  The height of the page cannot be specified as yet. WebShot will attempt to 
 *  get the *entire* page.
 */
@property (nonatomic) CGFloat browserWidth;

/**
 *  @name Controlling the delegate queue.
 */

/**
 *  The dispatch queue on which the completion block (`WSCompletionBlock`) will 
 *  be executed.
 *
 *  @discussion
 *  All internal rendering commands are executed on the main queue. This cannot
 *  be changed. This parameter only controls what happens *after* the WebShot
 *  has done its job. If you don't specify a queue, the completion block will be
 *  executed on the main queue.
 */
@property (nonatomic, strong) dispatch_queue_t delegateQueue;

/**
 *  @name Creating a new `CSWebShot` instance
 */

/**
 *  Returns a new instance of `CSWebShot` initialized with the specified URL.
 *
 *  @param URL  The URL to be fetched.
 *
 *  @returns A new `CSWebShot` object.
 */
- (nonnull instancetype)initWithURL:(NSURL * _Nullable)URL NS_DESIGNATED_INITIALIZER;

/**
 *  @name Fetching a PNG rendering of the page
 */

/**
 *  Fetches a PNG image of the fully rendered page.
 *
 *  @param completion   The callback to be executed when the action completes.
 *
 *  @discussion
 *  The `data` parameter of the `WSCompletionBlock` will be populated with PNG
 *  bytes.
 */
- (void)webshotWithCompletion:(WSCompletionBlock)completion;
 
/**
 *  @name Fetching the rendered HTML content of the page
 */

/**
 *  Fetches rendered HTML content of the page.
 *
 *  @param completion   The callback to be executed when the action completes.
 *
 *  @discussion
 *  The `data` parameter of the `WSCompletionBlock` will be populated with plain
 *  text containing the source of the page, as the browser *sees* it.
 */
- (void)renderedHTMLWithCompletion:(WSCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
