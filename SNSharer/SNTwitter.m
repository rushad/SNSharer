//
//  SNTwitter.m
//  SNSharer
//
//  Created by Rushad on 6/23/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNTwitter.h"

#import "SNSocialFramework.h"
#import "SNWebInterface.h"

@interface SNTwitter()

@property (strong, nonatomic) UIViewController* parentViewController;
@property (nonatomic, readonly) BOOL nativeSupport;
@property (strong, nonatomic) SNWebInterface* webInterface;

@end

@implementation SNTwitter

#pragma mark - Initializer

- (instancetype)initWithParentViewController:(UIViewController*)parentViewController
{
    self = [super init];
    if (self)
    {
        _parentViewController = parentViewController;
        _nativeSupport = ([SLComposeViewController class] && [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]);
    }
    return self;
}

#pragma mark - SNServiceProtocol

- (BOOL)isTextSupported
{
    return true;
}

- (BOOL)isUrlSupported
{
    return true;
}

- (BOOL)isImageSupported
{
    return self.nativeSupport;
}

- (void)shareText:(NSString*)text
              url:(NSString*)url
            image:(UIImage*)image
{
    if (self.nativeSupport)
    {
        NSString* body = text;
        if (url)
        {
            body = [body stringByAppendingString:@"\r\n"];
            body = [body stringByAppendingString:url];
        }
        UIViewController* composer = [SNSocialFramework composeViewControllerForService:SLServiceTypeTwitter
                                                                                   text:body
                                                                                    url:nil
                                                                                  image:image];
        [self.parentViewController presentViewController:composer animated:YES completion:nil];
    }
    else
    {
        self.webInterface = [[SNWebInterface alloc] initWithServiceName:@"Twitter"
                                                            urlTemplate:@"http://twitter.com/share?text=%@&url=%@"
                                                   parentViewController:self.parentViewController];
        [self.webInterface shareText:text
                                 url:url];
    }
}

@end
