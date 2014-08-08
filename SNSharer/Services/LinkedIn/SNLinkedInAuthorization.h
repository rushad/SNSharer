//
//  SNLinkedInAuthorization.h
//  SNSharer
//
//  Created by Rushad Nabiullin on 7/24/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "OAuth20.h"

#import <Foundation/Foundation.h>

@interface SNLinkedInAuthorization : NSOperation

- (instancetype)init __attribute__((unavailable("Default initializer is deprecated.")));

- (instancetype)initWithParentViewController:(UIViewController*)parentViewController
                                      apiKey:(NSString*)apiKey
                                   secretKey:(NSString*)secretKey
                                 redirectUrl:(NSString*)redirectUrl;

@property (readonly) OAuth20* oauth;

@end
