//
//  SNEmail.m
//  SNSharer
//
//  Created by Rushad on 6/20/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNEmail.h"

#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>

@interface SNEmail()<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) UIViewController* parentViewController;

@property (nonatomic, copy) void (^shareCompletionHandler)(SNShareResult result, NSString* error);

@end

@implementation SNEmail

#pragma mark - Initializer

- (instancetype)initWithParentViewController:(UIViewController*)parentViewController
{
    if (![MFMailComposeViewController canSendMail])
        return nil;
    
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
    return [MFMailComposeViewController canSendMail];
}

+ (BOOL)canShareLocalImage
{
    return YES;
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

#pragma mark - Private methods

- (void)shareWithTitle:(NSString*)title
                  text:(NSString*)text
                   url:(NSString*)url
                 image:(UIImage*)image
              imageUrl:(NSString*)imageUrl
     completionHandler:(void (^)(SNShareResult result, NSString* error))handler
{
    self.shareCompletionHandler = handler;
    
    MFMailComposeViewController* mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    
    NSString* body = text;
    if (url)
    {
        body = [body stringByAppendingString:@"\r\n"];
        body = [body stringByAppendingString:url];
    }
    [mailComposer setSubject:title];
    [mailComposer setMessageBody:body isHTML:NO];
    [mailComposer addAttachmentData:UIImagePNGRepresentation(image) mimeType:@"image/png" fileName:@"attachment.png"];
    
    [self.parentViewController presentViewController:mailComposer animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    switch(result)
    {
        case MFMailComposeResultSent:
            self.shareCompletionHandler(SNShareResultDone, nil);
            break;
        case MFMailComposeResultSaved:
        case MFMailComposeResultCancelled:
            self.shareCompletionHandler(SNShareResultCancelled, error.description);
            break;
        case MFMailComposeResultFailed:
            self.shareCompletionHandler(SNShareResultFailed, error.description);
            break;
    }
}

@end
