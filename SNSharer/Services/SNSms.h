//
//  SNSms.h
//  SNSharer
//
//  Created by Rushad on 6/20/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNServiceProtocol.h"

#import <Foundation/Foundation.h>

@interface SNSms : NSObject<SNServiceProtocol>

- (instancetype)initWithParentViewController:(UIViewController*)parentViewController;

@end
