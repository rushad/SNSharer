//
//  SNLinkedInAuthorization.m
//  SNSharer
//
//  Created by Rushad Nabiullin on 7/24/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNLinkedInAuthorization.h"

@interface SNLinkedInAuthorization()

@property (strong, nonatomic) UIViewController* parentViewController;

@property (strong, nonatomic) NSString* apiKey;
@property (strong, nonatomic) NSString* secretKey;
@property (strong, nonatomic) NSString* redirectUrl;

@property (strong) NSCondition* cond;

@property (strong, nonatomic, readwrite) OAuth20* oauth;

@property (getter = isFinished) BOOL finished;

@end

@implementation SNLinkedInAuthorization

static NSString* const urlAuthorization = @"https://www.linkedin.com/uas/oauth2/authorization";
static NSString* const urlAccessToken = @"https://www.linkedin.com/uas/oauth2/accessToken";

#pragma mark - Initializer

- (instancetype)initWithParentViewController:(UIViewController *)parentViewController
                                      apiKey:(NSString *)apiKey
                                   secretKey:(NSString *)secretKey
                                 redirectUrl:(NSString *)redirectUrl
{
    self = [super init];
    if (self)
    {
        _parentViewController = parentViewController;
        _apiKey = apiKey;
        _secretKey = secretKey;
        _redirectUrl = redirectUrl;
        _cond = [[NSCondition alloc] init];
    }
    return self;
}

#pragma mark - Operation startpoint

- (void)main
{
    @autoreleasepool
    {
//        [self performSelectorOnMainThread:@selector(authorize) withObject:nil waitUntilDone:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self authorize];
        });
        
        [self.cond lock];
        
        while (![self isFinished])
        {
            [self.cond wait];
        }
        
        [self.cond unlock];
    }
}

#pragma mark - Private methods

- (void)authorize
{
    self.oauth = [[OAuth20 alloc] initWithAuthorizationURL:urlAuthorization
                                            accessTokenURL:urlAccessToken
                                               redirectURL:self.redirectUrl
                                                    apiKey:self.apiKey
                                                 secretKey:self.secretKey
                                      parentViewController:self.parentViewController];
    
    [self.oauth authorizeWithScope:@""
                             state:[NSString stringWithFormat:@"%ld", random()]
                 completionHandler:^(BOOL accessGranted, NSString *error, NSString *errorDescription)
     {
         [self.cond lock];
         
         self.finished = YES;
         [self.cond signal];
         
         [self.cond unlock];
     }];
}

@end
