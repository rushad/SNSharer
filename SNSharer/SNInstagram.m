//
//  SNInstagram.m
//  SNSharer
//
//  Created by Rushad on 6/23/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNInstagram.h"

@interface SNInstagram()

@property (strong, nonatomic) UIViewController* parentViewController;
@property (strong, nonatomic) UIDocumentInteractionController* instagramController;

@end

@implementation SNInstagram

#pragma mark - Initializer

- (instancetype)initWithParentViewController:(UIViewController*)parentViewController
{
    self = [super init];
    if (self)
    {
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"instagram://"]])
            return nil;
        _parentViewController = parentViewController;
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
    return true;
}

- (void)shareText:(NSString*)text
              url:(NSString*)url
            image:(UIImage*)image
{
    NSString* tempFileName = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"temp.igo"];
    [UIImagePNGRepresentation(image) writeToFile:tempFileName atomically:YES];

    self.instagramController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:tempFileName]];
    NSString* body = text;
    if (url)
    {
        body = [body stringByAppendingString:@"\r\n"];
        body = [body stringByAppendingString:url];
    }

    self.instagramController.annotation = @{@"InstagramCaption": body};
    
    [self.instagramController presentOpenInMenuFromRect:self.parentViewController.view.frame inView:self.parentViewController.view animated:YES];
}

@end
