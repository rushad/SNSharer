//
//  SNVKontakte.m
//  SNSharer
//
//  Created by Rushad on 7/8/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNVKontakte.h"

#import "OAuth20.h"

@interface SNVKontakte()<OAuth20Delegate>

@property (strong, nonatomic) UIViewController* parentViewController;
@property (strong, nonatomic) OAuth20* oauth;

@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* url;

@end

@implementation SNVKontakte

static NSString* const urlAuthorization = @"https://oauth.vk.com/authorize";
static NSString* const urlAccessToken = @"https://www.linkedin.com/uas/oauth2/accessToken";
static NSString* const urlRedirect = @"http://helpbook.com";

static NSString* const APIKey = @"4451310";
static NSString* const secretKey = @"DWkpMeHUuy6gHOZDxxrb";

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
    return YES;
}

- (BOOL)isUrlSupported
{
    return YES;
}

- (BOOL)isImageSupported
{
    return NO;
}

- (void)shareText:(NSString*)text
              url:(NSString*)url
            image:(UIImage*)image
{
    self.oauth = [[OAuth20 alloc] initWithAuthorizationURL:urlAuthorization
                                            accessTokenURL:urlAccessToken
                                               redirectURL:urlRedirect
                                                    apiKey:APIKey
                                                 secretKey:secretKey
                                      parentViewController:self.parentViewController];
    self.oauth.delegate = self;
    
    self.text = text;
    self.url = url;
    
    [self.oauth authorizeWithScope:@"" state:@"1234"];
}

#pragma mark - OAuthDelegate

- (void)accessGranted
{
    NSLog(@"VKontakte: access granted");
}

- (void)accessDenied
{
    NSLog(@"VKontakte: access denied");
}

@end
