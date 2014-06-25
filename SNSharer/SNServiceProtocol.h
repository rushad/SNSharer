//
//  SNServiceProtocol.h
//  SNSharer
//
//  Created by Rushad on 6/20/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SNServiceProtocol <NSObject>

- (instancetype)init __attribute__((unavailable("Must use initWithParentViewController: instead.")));
- (instancetype)initWithParentViewController:(UIViewController*)parentViewController;

- (BOOL)isTextSupported;
- (BOOL)isUrlSupported;
- (BOOL)isImageSupported;

- (void)shareText:(NSString*)text url:(NSString*)url image:(UIImage*)image;

@end
