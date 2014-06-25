//
//  SNSocialFramework.m
//  SNSharer
//
//  Created by Rushad on 6/23/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNSocialFramework.h"

@implementation SNSocialFramework

+ (UIViewController*)composeViewControllerForService:(NSString*)service
                                                text:(NSString*)text
                                                 url:(NSString*)url
                                               image:(UIImage*)image;
{
    SLComposeViewController* composer = [SLComposeViewController composeViewControllerForServiceType:service];
    [composer setInitialText:text];
    [composer addURL:[NSURL URLWithString:url]];
    [composer addImage:image];
    
    return composer;
}

@end
