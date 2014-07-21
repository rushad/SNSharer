//
//  SNLinkedIn.h
//  SNSharer
//
//  Created by Rushad on 7/1/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNServiceProtocol.h"

#import <Foundation/Foundation.h>

@interface SNLinkedIn : NSObject<SNServiceProtocol>

- (instancetype)initWithParentViewController:(UIViewController*)parentViewController
                                      apiKey:(NSString*)apiKey
                                   secretKey:(NSString*)secretKey
                                 redirectUrl:(NSString*)redirectUrl;

@end
