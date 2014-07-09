//
//  SNFacebook.m
//  SNSharer
//
//  Created by Rushad on 6/23/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNFacebook.h"

#import "SNSocialFramework.h"
#import "SNWebInterface.h"

@interface SNFacebook()

@property (strong, nonatomic) UIViewController* parentViewController;
@property (strong, nonatomic) SNWebInterface* webInterface;

@end

@implementation SNFacebook

#pragma mark - Initializer

- (instancetype)initWithParentViewController:(UIViewController*)parentViewController
{
    self = [super init];
    if (self)
    {
        _parentViewController = parentViewController;
    }
    return self;
}

#pragma mark - SNServiceProtocol

+ (BOOL)isAvailable
{
    return true;
}

+ (BOOL)canShareLocalImage
{
    return true;
}

- (void)shareWithTitle:(NSString*)title
                  text:(NSString*)text
                   url:(NSString*)url
                 image:(UIImage*)image
     completionHandler:(void (^)(SNShareResult, NSString *))handler
{
    if ([SLComposeViewController class] && [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        UIViewController* composer = [SNSocialFramework composeViewControllerForService:SLServiceTypeFacebook
                                                                                   text:text
                                                                                    url:url
                                                                                  image:image
                                                                      completionHandler:handler];
        
        [self.parentViewController presentViewController:composer animated:YES completion:nil];
    }
    else
    {
        self.webInterface = [[SNWebInterface alloc] initWithServiceName:@"Facebook"
                                                            urlTemplate:@"http://www.facebook.com/sharer.php?t=%@&u=%@"
                                                   parentViewController:self.parentViewController
                                                      completionHandler:handler];
        
        [self.webInterface shareText:text
                                 url:url];
    }
}

- (void)shareWithTitle:(NSString*)title
                  text:(NSString*)text
                   url:(NSString*)url
              imageUrl:(NSString*)imageUrl
     completionHandler:(void (^)(SNShareResult, NSString *))handler
{
}

@end
