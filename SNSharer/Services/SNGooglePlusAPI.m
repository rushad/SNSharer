//
//  SNGooglePlusAPI.m
//  SNSharer
//
//  Created by Rushad Nabiullin on 7/22/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNGooglePlusAPI.h"

#import "OAuth20.h"

@interface SNGooglePlusAPI()<OAuth20Delegate>

@property (strong, nonatomic) UIViewController* parentViewController;

@property (strong, nonatomic) NSString* clientId;
@property (strong, nonatomic) NSString* clientSecret;
@property (strong, nonatomic) NSString* redirectUri;

@property (strong, nonatomic) OAuth20* oauth;

@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* url;
//@property (strong, nonatomic) NSString* imageUrl;

@property (nonatomic, copy) void (^shareCompletionHandler)(SNShareResult result, NSString* error);

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

#pragma mark - Private methods

- (void)shareWithTitle:(NSString*)title
                  text:(NSString*)text
                   url:(NSString*)url
                 image:(UIImage*)image
              imageUrl:(NSString*)imageUrl
     completionHandler:(void (^)(SNShareResult, NSString *))handler
{
    self.shareCompletionHandler = handler;
    
    self.oauth = [[OAuth20 alloc] initWithAuthorizationURL:urlAuthorization
                                            accessTokenURL:urlAccessToken
                                               redirectURL:self.redirectUri
                                                    apiKey:self.clientId
                                                 secretKey:self.clientSecret
                                      parentViewController:self.parentViewController];
    self.oauth.delegate = self;
    
    self.text = text;
    self.url = url;
    
    [self.oauth authorizeWithScope:@"https://www.googleapis.com/auth/plus.login" state:[NSString stringWithFormat:@"%ld", random()]];
}

- (void)share
{
/*    NSString* xmlShare = [NSString stringWithFormat:
                          @"<share>"
                          "  <comment></comment>"
                          "  <content>"
                          "    <title></title>"
                          "    <description>%@</description>"
                          "    <submitted-url>%@</submitted-url>"
                          "    <submitted-image-url>%@</submitted-image-url>"
                          "  </content>"
                          "  <visibility>"
                          "    <code>anyone</code>"
                          "  </visibility>"
                          "</share>",
                          self.text, self.url, self.imageUrl];
    
    [self.oauth postResourceByQuery:@"https://api.linkedin.com/v1/people/~/shares"
                   headerParameters:@{ @"Content-Type" : @"text/xml" }
                               body:xmlShare
                  completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         self.shareCompletionHandler(error ? SNShareResultFailed : SNShareResultDone, nil);
     }];*/
    NSLog(@"Access granted");
}

#pragma mark - OAuth20Delegate

- (void)accessGranted
{
    /*
     [self.oauth getResourceByQuery:@"https://api.linkedin.com/v1/people/~"
     parameters:nil
     completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
     NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
     }];
     */
    [self share];
}

- (void)accessDenied
{
    self.shareCompletionHandler(SNShareResultFailed, nil);
}

@end
