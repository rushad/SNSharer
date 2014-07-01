//
//  SNFacebook.m
//  SNSharer
//
//  Created by Rushad on 6/23/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNFacebook.h"

#import "SNSocialFramework.h"
#import "SNWebInterface.h"

@interface SNFacebook()

@property (strong, nonatomic) UIViewController* parentViewController;
@property (nonatomic, readonly) BOOL nativeSupport;
@property (strong, nonatomic) SNWebInterface* webInterface;

@end

@implementation SNFacebook

#pragma mark - Initializer

- (instancetype)initWithParentViewController:(UIViewController*)parentViewController
{
    self = [super init];
    if (self)
    {
        _parentViewController = parentViewController;
        _nativeSupport = ([SLComposeViewController class] && [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]);
    }
    return self;
}

#pragma mark - SNServiceProtocol

- (BOOL)isTextSupported
{
    return self.nativeSupport;
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
        UIViewController* composer = [SNSocialFramework composeViewControllerForService:SLServiceTypeFacebook
                                                                                   text:text
                                                                                    url:url
                                                                                  image:image];
        [self.parentViewController presentViewController:composer animated:YES completion:nil];
    }
    else
    {
        self.webInterface = [[SNWebInterface alloc] initWithServiceName:@"Facebook"
                                                                       urlTemplate:@"http://www.facebook.com/sharer.php?t=%@&u=%@"
                                                              parentViewController:self.parentViewController];
        [self.webInterface shareText:text
                                 url:url];
    }
}

@end
