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
    return [MFMessageComposeViewController canSendAttachments];
}

- (void)shareText:(NSString*)text
              url:(NSString*)url
            image:(UIImage*)image
{
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

#pragma mark - Delegates

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
