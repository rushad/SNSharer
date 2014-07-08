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
@property (strong, nonatomic) OAuth20* oauth;

@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* url;

@end

@implementation SNLinkedIn

static NSString* const urlAuthorization = @"https://www.linkedin.com/uas/oauth2/authorization";
static NSString* const urlAccessToken = @"https://www.linkedin.com/uas/oauth2/accessToken";
static NSString* const urlRedirect = @"http://helpbook.com";

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

    [self.oauth postResourceByQuery:@"https://api.linkedin.com/v1/people/~/shares"
                   headerParameters:@{ @"Content-Type" : @"text/xml" }
                               body:xmlShare
                          onSuccess:^(NSString* body)
                                          {
                                              UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"LinkedIn"
                                                                                              message:@"You shared info successfully!"
                                                                                             delegate:nil
                                                                                    cancelButtonTitle:@"OK"
                                                                                    otherButtonTitles:nil];
                                              [alert show];
                                          }];
}

#pragma mark - OAuthDelegate

- (void)accessGranted
{
/*
    [self.oauth getResourceByQuery:@"https://api.linkedin.com/v1/people/~"
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
