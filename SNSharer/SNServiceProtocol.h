//
//  SNServiceProtocol.h
//  SNSharer
//
//  Created by Rushad on 6/20/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SNServiceProtocol

- (instancetype)init __attribute__((unavailable("Must use initWithParentViewController: instead.")));
- (instancetype)initWithParentViewController:(UIViewController*)parentViewController;

- (BOOL)isTextSupported;
- (BOOL)isUrlSupported;
- (BOOL)isImageSupported;

- (void)shareText:(NSString*)text url:(NSString*)url image:(UIImage*)image;

@end

typedef NS_ENUM(NSUInteger, SNShareResult)
{
    SNShareResultDone,
    SNShareResultCancelled,
    SNShareResultFailed,
    SNShareResultUnknown
};

@protocol SNServiceProtocol2

- (instancetype)init __attribute__((unavailable("Default initializer is deprecated.")));

+ (BOOL)isAvailable;
+ (BOOL)canShareLocalImage;

- (void)shareWithTitle:(NSString*)title
                  text:(NSString*)text
                   url:(NSString*)url
              imageUrl:(NSString*)imageUrl
     completionHandler:(void (^)(SNShareResult result, NSString* error))handler;

- (void)shareWithTitle:(NSString*)title
                  text:(NSString*)text
                   url:(NSString*)url
                 image:(UIImage*)image
     completionHandler:(void (^)(SNShareResult result, NSString* error))handler;

@end