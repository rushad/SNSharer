//
//  OAuth10.h
//  SNSharer
//
//  Created by Rushad on 7/1/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAuth10 : NSObject

- (instancetype)initWithRequestTokenURL:(NSString*)urlRequestToken
                           authorizeURL:(NSString*)urlAuthorize
                         accessTokenURL:(NSString*)urlAccesToken
                            consumerKey:(NSString*)consumerKey
                              signature:(NSString*)signature;

- (void)authorize;

@end
