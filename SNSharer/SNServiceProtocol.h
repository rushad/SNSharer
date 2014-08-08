//
//  SNServiceProtocol.h
//  SNSharer
//
//  Created by Rushad on 6/20/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SNShareResult)
{
    SNShareResultDone,
    SNShareResultCancelled,
    SNShareResultFailed,
    SNShareResultNotSupported,
    SNShareResultUnknown
};

@protocol SNServiceProtocol

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

- (void)retrieveProfileWithCompletionHandler:(void (^)(SNShareResult result, NSDictionary* profile, NSString* error))handler;

@end