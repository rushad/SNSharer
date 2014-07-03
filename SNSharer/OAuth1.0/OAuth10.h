//
//  OAuth10.h
//  SNSharer
//
//  Created by Rushad on 7/1/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OAuth10Delegate

- (void)accessGranted;
- (void)accessRefused;

@end

@interface OAuth10 : NSObject

@property (weak, nonatomic) id<OAuth10Delegate> delegate;

- (instancetype)initWithRequestTokenURL:(NSString*)urlRequestToken
                           authorizeURL:(NSString*)urlAuthorize
                         accessTokenURL:(NSString*)urlAccesToken
                           submittedURL:(NSString*)urlSubmitted
                   jsGettingAccessToken:(NSString*)jsGettingAccessToken
                            consumerKey:(NSString*)consumerKey
                              signature:(NSString*)signature
                   parentViewController:(UIViewController*)parentViewController;

- (void)authorize;

- (NSString*)getResourceByRequest:(NSString*)urlRequest
                       parameters:(NSDictionary*)parameters;

+ (NSString*)URLEncodeString:(NSString*)string;

+ (NSString*)signatureBaseStringUrl:(NSString*)url
                         parameters:(NSDictionary*)parameters;

+ (NSString*)signText:(NSString*)text
       consumerSecret:(NSString*)consumerSecret
          tokenSecret:(NSString*)tokenSecret;

+ (NSString*)stringOfParameters:(NSDictionary*)parameters;

+ (NSDictionary*)dictionaryFromURLParametersString:(NSString*)string;

@end
