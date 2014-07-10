//
//  SNLinkedIn.m
//  SNSharer
//
//  Created by Rushad on 7/1/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNLinkedIn.h"

#import "OAuth20.h"

@interface SNLinkedIn()<OAuth20Delegate>

@property (strong, nonatomic) UIViewController* parentViewController;

@property (strong, nonatomic) NSString* apiKey;
@property (strong, nonatomic) NSString* secretKey;
@property (strong, nonatomic) NSString* redirectUrl;

@property (strong, nonatomic) OAuth20* oauth;

@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* url;
@property (strong, nonatomic) NSString* imageUrl;

@property (nonatomic, copy) void (^shareCompletionHandler)(SNShareResult result, NSString* error);

@end

@implementation SNLinkedIn

static NSString* const urlAuthorization = @"https://www.linkedin.com/uas/oauth2/authorization";
static NSString* const urlAccessToken = @"https://www.linkedin.com/uas/oauth2/accessToken";

#pragma mark - Initializer

- (instancetype)initWithParentViewController:(UIViewController*)parentViewController
                                      apiKey:(NSString*)apiKey
                                   secretKey:(NSString*)secretKey
                                 redirectUrl:(NSString*)redirectUrl
{
    self = [super init];
    if (self)
    {
        _parentViewController = parentViewController;
        _apiKey = apiKey;
        _secretKey = secretKey;
        _redirectUrl = redirectUrl;
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
                                               redirectURL:self.redirectUrl
                                                    apiKey:self.apiKey
                                                 secretKey:self.secretKey
                                      parentViewController:self.parentViewController];
    self.oauth.delegate = self;
    
    self.text = text;
    self.url = url;
    self.imageUrl = imageUrl;
    
    [self.oauth authorizeWithScope:@"" state:[NSString stringWithFormat:@"%ld", random()]];
}

- (void)share
{
    NSString* xmlShare = [NSString stringWithFormat:
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
                                     }];
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
