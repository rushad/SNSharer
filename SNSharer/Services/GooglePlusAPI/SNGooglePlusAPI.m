//
//  SNGooglePlusAPI.m
//  SNSharer
//
//  Created by Rushad Nabiullin on 7/22/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNGooglePlusAPI.h"

#import "OAuth20.h"

@interface SNGooglePlusAPI()

@property (strong, nonatomic) UIViewController* parentViewController;

@property (strong, nonatomic) NSString* clientId;
@property (strong, nonatomic) NSString* clientSecret;
@property (strong, nonatomic) NSString* redirectUri;

@property (strong, nonatomic) OAuth20* oauth;

@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* url;
//@property (strong, nonatomic) NSString* imageUrl;

@property (nonatomic, copy) void (^profileCompletionHandler)(SNShareResult result, NSDictionary* profile, NSString* error);

@end

@implementation SNGooglePlusAPI

static NSString* const urlAuthorization = @"https://accounts.google.com/o/oauth2/auth";
static NSString* const urlAccessToken = @"https://accounts.google.com/o/oauth2/token";

#pragma mark - Initializer

- (instancetype)initWithParentViewControlller:(UIViewController*)parentViewController
                                     clientId:(NSString*)clientId
                                 clientSecret:(NSString*)clientSecret
                                  redirectUri:(NSString*)redirectUri

{
    self = [super init];
    if (self)
    {
        _parentViewController = parentViewController;
        _clientId = clientId;
        _clientSecret = clientSecret;
        _redirectUri = redirectUri;
    }
    return self;
}

#pragma mark - SNServiceProtocol

+ (BOOL)isAvailable
{
    return YES;
}

+ (BOOL)canShareLocalImage
{
    return NO;
}

- (void)shareWithTitle:(NSString*)title
                  text:(NSString*)text
                   url:(NSString*)url
                 image:(UIImage*)image
     completionHandler:(void (^)(SNShareResult, NSString *))handler
{
    [self shareWithTitle:title
                    text:text
                     url:url
                   image:image
                imageUrl:nil
       completionHandler:handler];
}

- (void)shareWithTitle:(NSString*)title
                  text:(NSString*)text
                   url:(NSString*)url
              imageUrl:(NSString*)imageUrl
     completionHandler:(void (^)(SNShareResult, NSString *))handler
{
    [self shareWithTitle:title
                    text:text
                     url:url
                   image:nil
                imageUrl:imageUrl
       completionHandler:handler];
}

- (void)retrieveProfileWithCompletionHandler:(void (^)(SNShareResult result, NSDictionary* profile, NSString* error))handler
{
//    handler(SNShareResultNotSupported, nil, @"Service doesn't support retrieving profile data");

    self.profileCompletionHandler = handler;
    
    self.oauth = [[OAuth20 alloc] initWithAuthorizationURL:urlAuthorization
                                            accessTokenURL:urlAccessToken
                                               redirectURL:self.redirectUri
                                                    apiKey:self.clientId
                                                 secretKey:self.clientSecret
                                      parentViewController:self.parentViewController];
    
    [self.oauth authorizeWithScope:@"https://www.googleapis.com/auth/plus.login"
                             state:[NSString stringWithFormat:@"%ld", random()]
                 completionHandler:^(BOOL accessGranted, NSString *error, NSString *errorDescription)
     {
         if (accessGranted)
         {
             [self getProfile];
         }
         else
         {
             self.profileCompletionHandler(SNShareResultFailed, nil, [NSString stringWithFormat:@"%@: %@", error, errorDescription]);
         }
     }];
}

#pragma mark - Private methods

- (void)shareWithTitle:(NSString*)title
                  text:(NSString*)text
                   url:(NSString*)url
                 image:(UIImage*)image
              imageUrl:(NSString*)imageUrl
     completionHandler:(void (^)(SNShareResult, NSString *))handler
{
    handler(SNShareResultFailed, @"Service doesn't support sharing");
}

- (void)getProfile
{
    [self.oauth getResourceByQuery:@"https://www.googleapis.com/plusDomains/v1/people/me"
                        parameters:@{ @"Content-Type" : @"application/json" }
                 completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
                                    {
                                        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                        self.profileCompletionHandler(error ? SNShareResultFailed : SNShareResultDone, json, [NSString stringWithFormat:@"%d: %@", error.code, error.description]);
                                    }];
}

@end
