//
//  SNInstagram.m
//  SNSharer
//
//  Created by Rushad on 6/23/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNInstagram.h"

@interface SNInstagram()<UIDocumentInteractionControllerDelegate>

@property (strong, nonatomic) UIViewController* parentViewController;
@property (strong, nonatomic) UIDocumentInteractionController* instagramController;

@property (nonatomic, copy) void (^shareCompletionHandler)(SNShareResult result, NSString* error);

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

+ (BOOL)isAvailable
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"instagram://"]];
}

+ (BOOL)canShareLocalImage
{
    return YES;
}

- (void)shareWithTitle:(NSString*)title
                  text:(NSString*)text
                   url:(NSString*)url
                 image:(UIImage*)image
     completionHandler:(void (^)(SNShareResult, NSString *))handler
{
    [self shareWithTitle:title
                    text:text
                     url:url
                   image:image
                imageUrl:nil
       completionHandler:handler];
}

- (void)shareWithTitle:(NSString*)title
                  text:(NSString*)text
                   url:(NSString*)url
              imageUrl:(NSString*)imageUrl
     completionHandler:(void (^)(SNShareResult, NSString *))handler
{
    [self shareWithTitle:title
                    text:text
                     url:url
                   image:nil
                imageUrl:imageUrl
       completionHandler:handler];
}

- (void)retrieveProfileWithCompletionHandler:(void (^)(SNShareResult result, NSDictionary* profile, NSString* error))handler
{
    handler(SNShareResultNotSupported, nil, @"Service doesn't support retrieving profile data");
}

#pragma mark - Private methods

- (void)shareWithTitle:(NSString*)title
                  text:(NSString*)text
                   url:(NSString*)url
                 image:(UIImage*)image
              imageUrl:(NSString*)imageUrl
     completionHandler:(void (^)(SNShareResult, NSString *))handler
{
    self.shareCompletionHandler = handler;
    
    NSString* tempFileName = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"temp.igo"];
    [UIImagePNGRepresentation(image) writeToFile:tempFileName atomically:YES];

    self.instagramController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:tempFileName]];
    self.instagramController.delegate = self;
    self.instagramController.UTI = @"com.instagram.exclusivegram";
    
    NSString* body = text;
    if (url)
    {
        body = [body stringByAppendingString:@"\r\n"];
        body = [body stringByAppendingString:url];
    }

    self.instagramController.annotation = @{@"InstagramCaption": body};
    
    [self.instagramController presentOpenInMenuFromRect:self.parentViewController.view.frame inView:self.parentViewController.view animated:YES];
}

#pragma mark - UIDocumentIteractionControllerDelegate

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller
{
    self.shareCompletionHandler(SNShareResultUnknown, nil);
}

@end
