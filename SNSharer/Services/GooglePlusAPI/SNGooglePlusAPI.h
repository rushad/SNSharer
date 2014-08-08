//
//  SNGooglePlusAPI.h
//  SNSharer
//
//  Created by Rushad Nabiullin on 7/22/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNServiceProtocol.h"

#import <Foundation/Foundation.h>

@interface SNGooglePlusAPI : NSObject<SNServiceProtocol>

- (instancetype)initWithParentViewControlller:(UIViewController*)parentViewController
                                     clientId:(NSString*)clientId
                                 clientSecret:(NSString*)clientSecret
                                  redirectUri:(NSString*)redirectUri;

@end
