//
//  SNPinterest.m
//  SNSharer
//
//  Created by Rushad on 7/9/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNPinterest.h"

#import <Pinterest/Pinterest.h>

@interface SNPinterest()

@property (strong, nonatomic) UIViewController* parentViewController;

@property (strong, nonatomic) Pinterest* pinterest;

@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* url;

@end

@implementation SNPinterest

#pragma mark - Initializer

- (instancetype)initWithParentViewController:(UIViewController*)parentViewController
{
    self = [super init];
    if (self)
    {
        _parentViewController = parentViewController;
        _pinterest = [[Pinterest alloc] initWithClientId:@"1438963"];
    }
    return self;
}

#pragma mark - SNServiceProtocol

- (BOOL)isTextSupported
{
    return true;
}

- (BOOL)isUrlSupported
{
    return true;
}

- (BOOL)isImageSupported
{
    return false;
}

- (void)shareText:(NSString*)text
              url:(NSString*)url
            image:(UIImage*)image
{
    [self.pinterest createPinWithImageURL:[NSURL URLWithString:@"http://www.helpbook.com"]
                                sourceURL:[NSURL URLWithString:@"url"]
                              description:text];
}
@end
