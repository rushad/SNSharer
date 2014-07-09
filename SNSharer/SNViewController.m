//
//  SNSViewController.m
//  SNSharer
//
//  Created by Rushad on 6/17/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNViewController.h"

#import "SNServiceProtocol.h"

#import "SNSharer.h"

#import "Services/SNEmail.h"
#import "Services/SNFacebook.h"
#import "Services/SNSms.h"
#import "Services/SNTwitter.h"

@interface SNViewController ()

@property (strong, nonatomic) id<SNServiceProtocol2> sharerEmail;
@property (strong, nonatomic) id<SNServiceProtocol2> sharerSMS;
@property (strong, nonatomic) id<SNServiceProtocol2> sharerFacebook;
@property (strong, nonatomic) id<SNServiceProtocol2> sharerTwitter;
@property (strong, nonatomic) SNSharer* sharerInstagram;
@property (strong, nonatomic) SNSharer* sharerGooglePlus;
@property (strong, nonatomic) SNSharer* sharerLinkedIn;
@property (strong, nonatomic) SNSharer* sharerPinterest;

@property (weak, nonatomic) IBOutlet UITextField *urlView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *shareViaEmail;
@property (weak, nonatomic) IBOutlet UIButton *shareViaSMS;
@property (weak, nonatomic) IBOutlet UIButton *shareViaFacebook;
@property (weak, nonatomic) IBOutlet UIButton *shareViaTwitter;
@property (weak, nonatomic) IBOutlet UIButton *shareViaInstagram;
@property (weak, nonatomic) IBOutlet UIButton *shareViaGooglePlus;
@property (weak, nonatomic) IBOutlet UIButton *shareViaLinkedIn;
@property (weak, nonatomic) IBOutlet UIButton *shareViaPinterest;

@property (nonatomic, copy) void (^completionHandler)(SNShareResult result, NSString* error);

@end

@implementation SNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.shareViaEmail.enabled = [SNEmail isAvailable];
    self.shareViaSMS.enabled = [SNSms isAvailable];
    self.shareViaFacebook.enabled = [SNFacebook isAvailable];
    self.shareViaTwitter.enabled = [SNTwitter isAvailable];

    self.sharerEmail = [[SNEmail alloc] initWithParentViewController:self];
    self.sharerSMS = [[SNSms alloc] initWithParentViewController:self];
    self.sharerFacebook = [[SNFacebook alloc] initWithParentViewController:self];
    self.sharerTwitter = [[SNTwitter alloc] initWithParentViewController:self];

    self.sharerInstagram = [[SNSharer alloc] initWithService:SERVICE_INSTAGRAM parentViewController:self];
    self.sharerGooglePlus = [[SNSharer alloc] initWithService:SERVICE_GOOGLEPLUS parentViewController:self];
    self.sharerLinkedIn = [[SNSharer alloc] initWithService:SERVICE_LINKEDIN parentViewController:self];
    self.sharerPinterest = [[SNSharer alloc] initWithService:SERVICE_PINTEREST parentViewController:self];
    
    self.shareViaInstagram.enabled = (self.sharerInstagram != nil);
    self.shareViaGooglePlus.enabled = (self.sharerGooglePlus != nil);
    self.shareViaLinkedIn.enabled = (self.sharerLinkedIn != nil);
    self.shareViaPinterest.enabled = (self.sharerPinterest != nil);

    self.completionHandler = ^(SNShareResult result, NSString* error)
    {
        switch(result)
        {
            case SNShareResultDone:
            {
                [[[UIAlertView alloc] initWithTitle:@"Done"
                                            message:@"You shared info successfully"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                break;
            }
            case SNShareResultCancelled:
            {
                [[[UIAlertView alloc] initWithTitle:@"Cancelled"
                                            message:@"You cancelled sharing"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                break;
            }
            case SNShareResultFailed:
            {
                [[[UIAlertView alloc] initWithTitle:@"Failed"
                                            message:@"Sharing failed"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                
                break;
            }
            default:
                NSLog(@"Unknown sharing result");
                break;
        }
    };
}

- (void)share:(SNSharer*)sharer
{
    [sharer shareText:self.textView.text url:self.urlView.text image:self.imageView.image];
}

- (IBAction)shareViaEmail:(id)sender
{
    [self.sharerEmail shareWithTitle:@"Title"
                                text:self.textView.text
                                 url:self.urlView.text
                               image:self.imageView.image
                   completionHandler:self.completionHandler];
}

- (IBAction)shareViaSMS:(id)sender
{
    [self.sharerSMS shareWithTitle:nil
                              text:self.textView.text
                               url:self.urlView.text
                             image:self.imageView.image
                 completionHandler:self.completionHandler];
}

- (IBAction)shareViaFacebook:(id)sender
{
    [self.sharerFacebook shareWithTitle:nil
                                   text:self.textView.text
                                    url:self.urlView.text
                                  image:self.imageView.image
                      completionHandler:self.completionHandler];
}

- (IBAction)shareViaTwitter:(id)sender
{
    [self.sharerTwitter shareWithTitle:nil
                                   text:self.textView.text
                                    url:self.urlView.text
                                  image:self.imageView.image
                      completionHandler:self.completionHandler];
}

- (IBAction)shareViaInstagram:(id)sender
{
    [self share:self.sharerInstagram];
}

- (IBAction)shareViaGooglePlus:(id)sender
{
    [self share:self.sharerGooglePlus];
}

- (IBAction)shareViaLinkedIn:(id)sender
{
    [self share:self.sharerLinkedIn];
}

- (IBAction)shareViaPinterest:(id)sender
{
    [self share:self.sharerPinterest];
}

@end
