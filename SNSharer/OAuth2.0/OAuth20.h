//
//  OAuth20.h
//  SNSharer
//
//  Created by Rushad on 7/7/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OAuth20Delegate<NSObject>

- (void)accessGranted;

@optional
- (void)accessDenied;

@end

@interface OAuth20 : NSObject

@property (weak, nonatomic) id<OAuth20Delegate> delegate;

#pragma mark - Initializer

- (instancetype)initWithAuthorizationURL:(NSString*)urlAuthirization
                          accessTokenURL:(NSString*)urlAccessToken
                             redirectURL:(NSString*)urlRedirect
                                  apiKey:(NSString*)apiKey
                               secretKey:(NSString*)secretKey
                    parentViewController:(UIViewController*)parentViewController;

#pragma mark - Public interface

- (void)authorizeWithScope:(NSString*)scope
                     state:(NSString*)state;

- (void)getResourceByQuery:(NSString*)urlQuery
                parameters:(NSDictionary*)parameters
                 onSuccess:(void (^)(NSString* body))onSuccessBlock;

- (void)postResourceByQuery:(NSString*)urlQuery
           headerParameters:(NSDictionary*)headerParameters
                       body:(NSString*)body
                  onSuccess:(void (^)(NSString* body))onSuccessBlock;

#pragma mark - Class methods (are public for unit testing)

+ (NSString*)URLEncodeString:(NSString*)string;

+ (NSString*)stringOfParameters:(NSDictionary*)parameters;

+ (NSString*)getPathOfUrl:(NSString*)url;

//+ (NSDictionary*)getParametersOfUrl:(NSString*)url;

@end
