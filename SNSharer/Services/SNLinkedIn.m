//
//  SNLinkedIn.m
//  SNSharer
//
//  Created by Rushad on 7/1/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNLinkedIn.h"

#import "OAuth10.h"

@interface SNLinkedIn()<OAuth10Delegate>

@property (strong, nonatomic) UIViewController* parentViewController;
@property (strong, nonatomic) OAuth10* oauth;

@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* url;

@end

@implementation SNLinkedIn

static NSString* const urlRequestToken = @"https://api.linkedin.com/uas/oauth/requestToken";
static NSString* const urlAuthorize = @"https://www.linkedin.com/uas/oauth/authenticate";
static NSString* const urlAccessToken = @"https://api.linkedin.com/uas/oauth/accessToken";
static NSString* const urlSubmitted = @"/uas/oauth/authorize/submit";
static NSString* const jsGettingAccessToken = @"document.getElementsByClassName('access-code')[0].innerHTML";

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
    return false;
}

- (void)shareText:(NSString*)text
              url:(NSString*)url
            image:(UIImage*)image
{
    self.oauth = [[OAuth10 alloc] initWithRequestTokenURL:urlRequestToken
                                             authorizeURL:urlAuthorize
                                           accessTokenURL:urlAccessToken
                                             submittedURL:urlSubmitted
                                     jsGettingAccessToken:jsGettingAccessToken
                                              consumerKey:APIKey
                                                signature:secretKey
                                     parentViewController:self.parentViewController];
    self.oauth.delegate = self;
    
    self.text = text;
    self.url = url;

    [self.oauth authorize];
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
                             "    <submitted-image-url></submitted-image-url>"
                             "  </content>"
                             "  <visibility>"
                             "    <code>anyone</code>"
                             "  </visibility>"
                             "</share>",
                            self.text, self.url];

    [self.oauth postResourceByQuery:@"http://api.linkedin.com/v1/people/~/shares"
                   headerParameters:@{ @"Content-Type" : @"text/xml" }
                               body:xmlShare
                          onSuccess:nil];/*^(NSString* body)
                                          {
                                              NSLog(@"LinkedIn response:\r\n%@", body);
                                          }];*/
}

#pragma mark - OAuthDelegate

- (void)accessGranted
{
/*
    [self.oauth getResourceByQuery:@"http://api.linkedin.com/v1/people/~"
                        parameters:nil
                         onSuccess:^(NSString* body)
                                    {
                                        NSLog(@"Body:\r\n%@", body);
                                    }];
*/
    [self share];
}
/*
- (void)accessDenied
{
    NSLog(@"LinkedIn: access denied");
}
*/
@end
