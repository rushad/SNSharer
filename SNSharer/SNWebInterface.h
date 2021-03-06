//
//  SNWebInterface.h
//  SNSharer
//
//  Created by Rushad on 6/23/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNServiceProtocol.h"

#import <Foundation/Foundation.h>

@interface SNWebInterface : NSObject

- (instancetype)initWithServiceName:(NSString*)serviceName
                        urlTemplate:(NSString*)urlTemplate
               parentViewController:(UIViewController*)parentViewController
                  completionHandler:(void (^)(SNShareResult result, NSString* error))handler;

- (void)shareText:(NSString*)text
              url:(NSString*)url;

@end
