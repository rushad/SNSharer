//
//  SNGooglePlus.m
//  SNSharer
//
//  Created by Rushad on 6/26/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNGooglePlus.h"

#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface SNGooglePlus()<GPPSignInDelegate>

@property (strong, nonatomic) UIViewController* parentViewController;
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* url;

@end

@implementation SNGooglePlus

static NSString* const clientID = @"11030147974-93rf3gj3vapmr7k5nhssm9evb1ud3ris.apps.googleusercontent.com";

#pragma mark - Initializer

- (instancetype)initWithParentViewController:(UIViewController*)parentViewController
{
    self = [super init];
    if (self)
    {
        _parentViewController = parentViewController;
        GPPSignIn *signIn = [GPPSignIn sharedInstance];
        signIn.shouldFetchGoogleUserID = YES;
        signIn.shouldFetchGoogleUserEmail = YES;
        signIn.clientID = clientID;
        signIn.scopes = @[ kGTLAuthScopePlusLogin ];
        signIn.delegate = self;
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
    self.text = text;
    self.url = url;
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    if (!signIn.authentication)
    {
        [signIn authenticate];
    }
    else
    {
        [self share];
    }
}

- (void)share
{
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    [shareBuilder setPrefillText:self.text];
    [shareBuilder setURLToShare:[NSURL URLWithString:self.url]];
    [shareBuilder open];
}

#pragma mark - GPPSignInDelegate

- (void)finishedWithAuth:(GTMOAuth2Authentication*)auth
                   error:(NSError*) error
{
    if (!error)
        [self share];
}

@end
