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

@end

@implementation SNPinterest

#pragma mark - Initializer

- (instancetype)initWithParentViewController:(UIViewController*)parentViewController
                                    clientId:(NSString *)clientId
{
    self = [super init];
    if (self)
    {
        _parentViewController = parentViewController;
        _pinterest = [[Pinterest alloc] initWithClientId:clientId];
    }
    return self;
}

#pragma mark - SNServiceProtocol

+ (BOOL)isAvailable
{
    return YES;
}

+ (BOOL)canShareLocalImage
{
    return NO;
}

- (void)shareWithTitle:(NSString*)title
                  text:(NSString*)text
                   url:(NSString*)url
              imageUrl:(NSString*)imageUrl
     completionHandler:(void (^)(SNShareResult result, NSString* error))handler
{
    [self shareWithTitle:title
                    text:text
                     url:url
                   image:nil
                imageUrl:imageUrl
       completionHandler:handler];
}

- (void)shareWithTitle:(NSString*)title
                  text:(NSString*)text
                   url:(NSString*)url
                 image:(UIImage*)image
     completionHandler:(void (^)(SNShareResult result, NSString* error))handler
{
    [self shareWithTitle:title
                    text:text
                     url:url
                   image:image
                imageUrl:nil
       completionHandler:handler];
}

#pragma mark - Private methods

- (void)shareWithTitle:(NSString*)title
                  text:(NSString*)text
                   url:(NSString*)url
                 image:(UIImage*)image
              imageUrl:(NSString*)imageUrl
     completionHandler:(void (^)(SNShareResult, NSString *))handler
{
    [self.pinterest createPinWithImageURL:[NSURL URLWithString:imageUrl]
                                sourceURL:[NSURL URLWithString:url]
                              description:text];
    
    handler(SNShareResultUnknown, nil);
}

@end
