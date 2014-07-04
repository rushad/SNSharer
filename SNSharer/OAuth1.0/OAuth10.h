//
//  OAuth10.h
//  SNSharer
//
//  Created by Rushad on 7/1/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OAuth10Delegate<NSObject>

- (void)accessGranted;

@optional
- (void)accessDenied;

@end

@interface OAuth10 : NSObject

@property (weak, nonatomic) id<OAuth10Delegate> delegate;

#pragma mark - Initializer

- (instancetype)initWithRequestTokenURL:(NSString*)urlRequestToken
                           authorizeURL:(NSString*)urlAuthorize
                         accessTokenURL:(NSString*)urlAccesToken
                           submittedURL:(NSString*)urlSubmitted
                   jsGettingAccessToken:(NSString*)jsGettingAccessToken
                            consumerKey:(NSString*)consumerKey
                              signature:(NSString*)signature
                   parentViewController:(UIViewController*)parentViewController;

#pragma mark - Public interface

- (void)authorize;

- (void)getResourceByQuery:(NSString*)urlQuery
                parameters:(NSDictionary*)parameters
                 onSuccess:(void (^)(NSString* body))onSuccessBlock;

- (void)postResourceByQuery:(NSString*)urlQuery
           headerParameters:(NSDictionary*)headerParameters
                       body:(NSString*)body
                  onSuccess:(void (^)(NSString* body))onSuccessBlock;

#pragma mark - Class methods (are public for unit testing)

+ (NSString*)URLEncodeString:(NSString*)string;

+ (NSString*)signatureBaseStringMethod:(NSString*)method
                                   url:(NSString*)url
                            parameters:(NSDictionary*)parameters;

+ (NSString*)signText:(NSString*)text
       consumerSecret:(NSString*)consumerSecret
          tokenSecret:(NSString*)tokenSecret;

+ (NSString*)stringOfParameters:(NSDictionary*)parameters;

+ (NSDictionary*)dictionaryFromURLParametersString:(NSString*)string;

@end
