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
                                               image:(UIImage*)image
                                   completionHandler:(void (^)(SNShareResult, NSString *))handler
{
    SLComposeViewController* composer = [SLComposeViewController composeViewControllerForServiceType:service];
    [composer setInitialText:text];
    [composer addURL:[NSURL URLWithString:url]];
    [composer addImage:image];
    
    composer.completionHandler = ^(SLComposeViewControllerResult result)
    {
        switch(result)
        {
            case SLComposeViewControllerResultCancelled:
                handler(SNShareResultCancelled, nil);
                break;
            case SLComposeViewControllerResultDone:
                handler(SNShareResultDone, nil);
                break;
        }
    };
    
    return composer;
}

@end
