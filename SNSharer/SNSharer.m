//
//  SNSharer.m
//  SNSharer
//
//  Created by Rushad on 6/19/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNSharer.h"

#import "SNServiceProtocol.h"
#import "SNGooglePlus.h"
#import "SNInstagram.h"
#import "SNLinkedIn.h"
#import "SNPinterest.h"
#import "SNVKontakte.h"

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
            case SERVICE_INSTAGRAM:
                _service = [[SNInstagram alloc] initWithParentViewController:parentViewController];
                break;
            case SERVICE_GOOGLEPLUS:
                _service = [[SNGooglePlus alloc] initWithParentViewController:parentViewController];
                break;
            case SERVICE_LINKEDIN:
                _service = [[SNLinkedIn alloc] initWithParentViewController:parentViewController];
                break;
            case SERVICE_PINTEREST:
                _service = [[SNPinterest alloc] initWithParentViewController:parentViewController];
                break;
            case SERVICE_VKONTAKTE:
                _service = [[SNVKontakte alloc] initWithParentViewController:parentViewController];
                break;
            default:
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
