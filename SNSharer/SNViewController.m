//
//  SNSViewController.m
//  SNSharer
//
//  Created by Rushad on 6/17/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNViewController.h"

#import "SNServiceProtocol.h"

#import "Services/SNEmail.h"
#import "Services/SNFacebook.h"
#import "Services/SNGooglePlus.h"
#import "Services/SNInstagram.h"
#import "Services/SNLinkedIn.h"
#import "Services/SNPinterest.h"
#import "Services/SNSms.h"
#import "Services/SNTwitter.h"

@interface SNViewController ()

@property (strong, nonatomic) id<SNServiceProtocol> sharerEmail;
@property (strong, nonatomic) id<SNServiceProtocol> sharerSMS;
@property (strong, nonatomic) id<SNServiceProtocol> sharerFacebook;
@property (strong, nonatomic) id<SNServiceProtocol> sharerTwitter;
@property (strong, nonatomic) id<SNServiceProtocol> sharerInstagram;
@property (strong, nonatomic) id<SNServiceProtocol> sharerGooglePlus;
@property (strong, nonatomic) id<SNServiceProtocol> sharerLinkedIn;
@property (strong, nonatomic) id<SNServiceProtocol> sharerPinterest;

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

static NSString* const googlePlusClientID = @"11030147974-93rf3gj3vapmr7k5nhssm9evb1ud3ris.apps.googleusercontent.com";

static NSString* const linkedInApiKey = @"77o77yemk1co4x";
static NSString* const linkedInSecretKey = @"UKLNKYM7kslt9STZ";
static NSString* const linkedInRedirectUrl = @"http://helpbook.com";

static NSString* const pinterestClientId = @"1438963";

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.shareViaEmail.enabled = [SNEmail isAvailable];
    self.shareViaSMS.enabled = [SNSms isAvailable];
    self.shareViaFacebook.enabled = [SNFacebook isAvailable];
    self.shareViaTwitter.enabled = [SNTwitter isAvailable];
    self.shareViaInstagram.enabled = [SNInstagram isAvailable];
    self.shareViaGooglePlus.enabled = [SNGooglePlus isAvailable];
    self.shareViaLinkedIn.enabled = [SNLinkedIn isAvailable];
    self.shareViaPinterest.enabled = [SNPinterest isAvailable];

    self.sharerEmail = [[SNEmail alloc] initWithParentViewController:self];
    self.sharerSMS = [[SNSms alloc] initWithParentViewController:self];
    self.sharerFacebook = [[SNFacebook alloc] initWithParentViewController:self];
    self.sharerTwitter = [[SNTwitter alloc] initWithParentViewController:self];
    self.sharerInstagram = [[SNInstagram alloc] initWithParentViewController:self];
    self.sharerGooglePlus = [[SNGooglePlus alloc] initWithParentViewController:self clientID:googlePlusClientID];
    self.sharerLinkedIn = [[SNLinkedIn alloc] initWithParentViewController:self
                                                                    apiKey:linkedInApiKey
                                                                 secretKey:linkedInSecretKey
                                                               redirectUrl:linkedInRedirectUrl];
    self.sharerPinterest = [[SNPinterest alloc] initWithParentViewController:self
                                                                    clientId:pinterestClientId];
    

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
    [self.sharerInstagram shareWithTitle:nil
                                    text:self.textView.text
                                     url:self.urlView.text
                                   image:self.imageView.image
                       completionHandler:self.completionHandler];
}

- (IBAction)shareViaGooglePlus:(id)sender
{
    [self.sharerGooglePlus shareWithTitle:nil
                                     text:self.textView.text
                                      url:self.urlView.text
                                    image:self.imageView.image
                        completionHandler:self.completionHandler];
}

- (IBAction)shareViaLinkedIn:(id)sender
{
    [self.sharerLinkedIn shareWithTitle:nil
                                   text:self.textView.text
                                    url:self.urlView.text
                               imageUrl:@"http://www.helpbook.com/images/logo_header.png"
                      completionHandler:self.completionHandler];
}

- (IBAction)shareViaPinterest:(id)sender
{
    [self.sharerPinterest shareWithTitle:nil
                                    text:self.textView.text
                                     url:self.urlView.text
                                imageUrl:@"http://www.helpbook.com/images/logo_header.png"
                       completionHandler:self.completionHandler];
}

@end
