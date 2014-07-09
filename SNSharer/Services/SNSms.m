//
//  SNSms.m
//  SNSharer
//
//  Created by Rushad on 6/20/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNSms.h"

#import <MessageUI/MessageUI.h>

@interface SNSms()<MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) UIViewController* parentViewController;

@property (nonatomic, copy) void (^shareCompletionHandler)(SNShareResult result, NSString* error);

@end

@implementation SNSms

#pragma mark - Initializer

- (instancetype)initWithParentViewController:(UIViewController*)parentViewController
{
    if (![MFMessageComposeViewController canSendText])
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
    return [MFMessageComposeViewController canSendText];
}

+ (BOOL)canShareLocalImage
{
    return true;
}

- (void)shareWithTitle:(NSString*)title
                  text:(NSString*)text
                   url:(NSString*)url
                 image:(UIImage*)image
     completionHandler:(void (^)(SNShareResult result, NSString* error))handler
{
    self.shareCompletionHandler = handler;
    
    MFMessageComposeViewController* smsComposer = [[MFMessageComposeViewController alloc] init];
    smsComposer.messageComposeDelegate = self;
    
    NSString* body = text;
    if (url)
    {
        body = [body stringByAppendingString:@"\r\n"];
        body = [body stringByAppendingString:url];
    }
    
    [smsComposer setBody:body];
    [smsComposer addAttachmentData:UIImagePNGRepresentation(image) typeIdentifier:@"public.png" filename:@"attachment.png"];
    
    [self.parentViewController presentViewController:smsComposer animated:YES completion:nil];
}

- (void)shareWithTitle:(NSString*)title
                  text:(NSString*)text
                   url:(NSString*)url
              imageUrl:(NSString*)imageUrl
     completionHandler:(void (^)(SNShareResult, NSString *))handler
{
}

#pragma mark - Delegates

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    switch(result)
    {
        case MessageComposeResultSent:
            self.shareCompletionHandler(SNShareResultDone, nil);
            break;
        case MessageComposeResultCancelled:
            self.shareCompletionHandler(SNShareResultCancelled, nil);
            break;
        case MessageComposeResultFailed:
            self.shareCompletionHandler(SNShareResultFailed, nil);
            break;
    }
}

@end
