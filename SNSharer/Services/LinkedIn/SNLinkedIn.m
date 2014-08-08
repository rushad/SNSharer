//
//  SNLinkedIn.m
//  SNSharer
//
//  Created by Rushad on 7/1/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNLinkedIn.h"

#import "SNLinkedInAuthorization.h"

#import "OAuth20.h"

@interface SNLinkedIn()

@property (strong, nonatomic) UIViewController* parentViewController;

@property (strong, nonatomic) NSString* apiKey;
@property (strong, nonatomic) NSString* secretKey;
@property (strong, nonatomic) NSString* redirectUrl;

@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* url;
@property (strong, nonatomic) NSString* imageUrl;

@property (nonatomic, copy) void (^shareCompletionHandler)(SNShareResult result, NSString* error);
@property (nonatomic, copy) void (^profileCompletionHandler)(SNShareResult result, NSDictionary* profile, NSString* error);

@property (strong, nonatomic) NSOperationQueue* queue;
@property (strong, nonatomic) SNLinkedInAuthorization* operationAuthorization;

@end

@implementation SNLinkedIn

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
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

#pragma mark - Lazy initialization

- (SNLinkedInAuthorization*)operationAuthorization
{
    if (!_operationAuthorization)
    {
        _operationAuthorization = [[SNLinkedInAuthorization alloc] initWithParentViewController:self.parentViewController
                                                                                         apiKey:self.apiKey
                                                                                      secretKey:self.secretKey
                                                                                    redirectUrl:self.redirectUrl];
        [self.queue addOperation:_operationAuthorization];
    }
    return _operationAuthorization;
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
     completionHandler:(void (^)(SNShareResult, NSString*))handler
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
     completionHandler:(void (^)(SNShareResult, NSString*))handler
{
    [self shareWithTitle:title
                    text:text
                     url:url
                   image:nil
                imageUrl:imageUrl
       completionHandler:handler];
}

- (void)retrieveProfileWithCompletionHandler:(void (^)(SNShareResult, NSDictionary *, NSString *))handler
{
    self.profileCompletionHandler = handler;
    
    NSBlockOperation* profileOperation = [NSBlockOperation blockOperationWithBlock:^{
        [self profile];
    }];
    
    [profileOperation addDependency:self.operationAuthorization];
    
    [self.queue addOperation:profileOperation];
}

#pragma mark - Private methods

- (void)shareWithTitle:(NSString*)title
                  text:(NSString*)text
                   url:(NSString*)url
                 image:(UIImage*)image
              imageUrl:(NSString*)imageUrl
     completionHandler:(void (^)(SNShareResult, NSString *))handler
{
    self.text = text;
    self.url = url;
    self.imageUrl = imageUrl;
    self.shareCompletionHandler = handler;
    
    NSBlockOperation* shareOperation = [NSBlockOperation blockOperationWithBlock:^{
        [self share];
    }];
    
    [shareOperation addDependency:self.operationAuthorization];
    
    [self.queue addOperation:shareOperation];
}

- (void)profile
{
    if (![self.operationAuthorization.oauth isAuthorized])
    {
        self.profileCompletionHandler(SNShareResultFailed, nil, @"Authorization failed");
        return;
    }
    
    [self.operationAuthorization.oauth getResourceByQuery:@"https://api.linkedin.com/v1/people/~"
                                               parameters:@{ @"format" : @"json" }
                                        completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         self.profileCompletionHandler(error ? SNShareResultFailed : SNShareResultDone, json, [NSString stringWithFormat:@"%d: %@", error.code, error.description]);
     }];
}

- (void)share
{
    if (![self.operationAuthorization.oauth isAuthorized])
    {
        self.shareCompletionHandler(SNShareResultFailed, @"Authorization failed");
        return;
    }
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

    [self.operationAuthorization.oauth postResourceByQuery:@"https://api.linkedin.com/v1/people/~/shares"
                                          headerParameters:@{ @"Content-Type" : @"text/xml" }
                                                      body:xmlShare
                                         completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
                                                           {
                                                               self.shareCompletionHandler(error ? SNShareResultFailed : SNShareResultDone, [NSString stringWithFormat:@"%d: %@", error.code, error.description]);
                                                           }];
}

@end
