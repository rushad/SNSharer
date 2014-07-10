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
@property (strong, nonatomic) NSString* clientID;

@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* url;
@property (strong, nonatomic) UIImage* image;

@property (strong, nonatomic) GPPSignIn* signIn;

@property (nonatomic, copy) void (^shareCompletionHandler)(SNShareResult result, NSString* error);

@end

@implementation SNGooglePlus

#pragma mark - Initializer

- (instancetype)initWithParentViewController:(UIViewController*)parentViewController
                                    clientID:(NSString *)clientID
{
    self = [super init];
    if (self)
    {
        _parentViewController = parentViewController;
        _clientID = clientID;
        
        _signIn = [GPPSignIn sharedInstance];
        _signIn.shouldFetchGoogleUserID = YES;
        _signIn.shouldFetchGoogleUserEmail = YES;
        _signIn.clientID = clientID;
        _signIn.scopes = @[ kGTLAuthScopePlusLogin ];
        _signIn.delegate = self;
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
    
    self.text = text;
    self.url = url;
    self.image = image;
    
    if (!self.signIn.authentication)
    {
        [self.signIn authenticate];
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
//    [shareBuilder attachImage:self.image];
    [shareBuilder open];
    self.shareCompletionHandler(SNShareResultUnknown, nil);
}

#pragma mark - GPPSignInDelegate

- (void)finishedWithAuth:(GTMOAuth2Authentication*)auth
                   error:(NSError*) error
{
    if (!error)
        [self share];
    else
        self.shareCompletionHandler(SNShareResultFailed, nil);
}

@end
