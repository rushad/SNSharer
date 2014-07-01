//
//  SNEmail.m
//  SNSharer
//
//  Created by Rushad on 6/20/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNEmail.h"

#import <MessageUI/MessageUI.h>

@interface SNEmail()<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) UIViewController* parentViewController;

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
    MFMailComposeViewController* mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    
    NSString* body = text;
    if (url)
    {
        body = [body stringByAppendingString:@"\r\n"];
        body = [body stringByAppendingString:url];
    }
    [mailComposer setSubject:nil];
    [mailComposer setMessageBody:body isHTML:NO];
    [mailComposer addAttachmentData:UIImagePNGRepresentation(image) mimeType:@"image/png" fileName:@"attachment.png"];
    
    [self.parentViewController presentViewController:mailComposer animated:YES completion:nil];
    
}

#pragma mark - Delegates

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
