//
//  SNLinkedIn.m
//  SNSharer
//
//  Created by Rushad on 7/1/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNLinkedIn.h"

#import "OAuth10.h"

@interface SNLinkedIn()

@property (strong, nonatomic) UIViewController* parentViewController;
@property (strong, nonatomic) OAuth10* oauth;

@end

@implementation SNLinkedIn

static NSString* const urlRequestToken = @"https://api.linkedin.com/uas/oauth/requestToken";
static NSString* const urlAuthorize = @"https://www.linkedin.com/uas/oauth/authenticate";
static NSString* const urlAccessToken = @"https://api.linkedin.com/uas/oauth/accessToken";
static NSString* const APIKey = @"77o77yemk1co4x";
static NSString* const secretKey = @"UKLNKYM7kslt9STZ";

#pragma mark - Initializer

- (instancetype)initWithParentViewController:(UIViewController*)parentViewController
{
    self = [super init];
    if (self)
    {
        _parentViewController = parentViewController;
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
    return true;
}

- (void)shareText:(NSString*)text
              url:(NSString*)url
            image:(UIImage*)image
{
    self.oauth = [[OAuth10 alloc] initWithRequestTokenURL:urlRequestToken
                                                 authorizeURL:urlAuthorize
                                               accessTokenURL:urlAccessToken
                                                  consumerKey:APIKey
                                                    signature:secretKey
                                         parentViewController:self.parentViewController];
    if ([self.oauth authorize])
    {
    }
}

@end
