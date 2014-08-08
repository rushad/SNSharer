//
//  SNPinterest.h
//  SNSharer
//
//  Created by Rushad on 7/9/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNServiceProtocol.h"

#import <Foundation/Foundation.h>

@interface SNPinterest : NSObject<SNServiceProtocol>

- (instancetype)initWithParentViewController:(UIViewController*)parentViewController
                                    clientId:(NSString*)clientId;

@end
