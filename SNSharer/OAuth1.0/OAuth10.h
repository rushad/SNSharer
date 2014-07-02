//
//  OAuth10.h
//  SNSharer
//
//  Created by Rushad on 7/1/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAuth10 : NSObject<UINavigationControllerDelegate>

- (instancetype)initWithRequestTokenURL:(NSString*)urlRequestToken
                           authorizeURL:(NSString*)urlAuthorize
                         accessTokenURL:(NSString*)urlAccesToken
                            consumerKey:(NSString*)consumerKey
                              signature:(NSString*)signature
                   parentViewController:(UIViewController*)parentViewController;

- (BOOL)authorize;

+ (NSString*)URLEncodeString:(NSString*)string;

+ (NSString*)signatureBaseStringUrl:(NSString*)url
                         parameters:(NSDictionary*)parameters;

+ (NSString*)signText:(NSString*)text
       consumerSecret:(NSString*)consumerSecret
          tokenSecret:(NSString*)tokenSecret;

+ (NSString*)stringOfParameters:(NSDictionary*)parameters;

+ (NSDictionary*)dictionaryFromURLParametersString:(NSString*)string;

@end
