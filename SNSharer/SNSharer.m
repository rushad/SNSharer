//
//  SNSharer.m
//  SNSharer
//
//  Created by Rushad on 6/19/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNSharer.h"

#import "SNServiceProtocol.h"
#import "SNEmail.h"
#import "SNFacebook.h"
#import "SNInstagram.h"
#import "SNSms.h"
#import "SNTwitter.h"

@interface SNSharer()

@property (nonatomic, strong, readonly) id<SNServiceProtocol> service;

@end

@implementation SNSharer

#pragma mark - Initializer

- (instancetype)initWithService:(ShareService)idService
           parentViewController:(UIViewController *)parentViewController
{
    self = [super init];
    if (self)
    {
        switch (idService)
        {
            case SERVICE_EMAIL:
                _service = [[SNEmail alloc] initWithParentViewController:parentViewController];
                break;
            case SERVICE_SMS:
                _service = [[SNSms alloc] initWithParentViewController:parentViewController];
                break;
            case SERVICE_FACEBOOK:
                _service = [[SNFacebook alloc] initWithParentViewController:parentViewController];
                break;
            case SERVICE_TWITTER:
                _service = [[SNTwitter alloc] initWithParentViewController:parentViewController];
                break;
            case SERVICE_INSTAGRAM:
                _service = [[SNInstagram alloc] initWithParentViewController:parentViewController];
                break;
        }
        if (!_service)
            return nil;
    }
    return self;
}

#pragma mark - SNServiceProtocol

- (BOOL)isTextSupported
{
    return [self.service isTextSupported];
}

- (BOOL)isUrlSupported
{
    return [self.service isUrlSupported];
}

- (BOOL)isImageSupported
{
    return [self.service isImageSupported];
}

- (void)shareText:(NSString *)text
              url:(NSString *)url
            image:(UIImage *)image
{
    [self.service shareText:text url:url image:image];
}

@end
