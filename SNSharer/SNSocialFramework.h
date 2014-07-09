//
//  SNSocialFramework.h
//  SNSharer
//
//  Created by Rushad on 6/23/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNServiceProtocol.h"

#import <Foundation/Foundation.h>
#import <Social/Social.h>

@interface SNSocialFramework : NSObject

+ (UIViewController*)composeViewControllerForService:(NSString*)service
                                                text:(NSString*)text
                                                 url:(NSString*)url
                                               image:(UIImage*)image
                                   completionHandler:(void (^)(SNShareResult result, NSString* error))handler;

@end
