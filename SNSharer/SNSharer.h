//
//  SNSharer.h
//  SNSharer
//
//  Created by Rushad on 6/19/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ShareService)
{
    SERVICE_EMAIL,
    SERVICE_SMS,
    SERVICE_FACEBOOK,
    SERVICE_TWITTER,
    SERVICE_INSTAGRAM
};

@interface SNSharer : NSObject

- (instancetype)init __attribute__((unavailable("Must use initWithService:parentViewController instead.")));

- (instancetype)initWithService:(ShareService)idService
           parentViewController:(UIViewController*)parentViewController;

- (BOOL)isTextSupported;
- (BOOL)isUrlSupported;
- (BOOL)isImageSupported;

- (void)shareText:(NSString*)text
              url:(NSString*)url
            image:(UIImage*)image;

@end
