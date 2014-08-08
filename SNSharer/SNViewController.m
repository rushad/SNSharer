//
//  SNSViewController.m
//  SNSharer
//
//  Created by Rushad on 6/17/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNViewController.h"

#import "SNServiceProtocol.h"

#import "SNEmail.h"
#import "SNFacebook.h"
#import "SNGooglePlus.h"
#import "SNGooglePlusAPI.h"
#import "SNInstagram.h"
#import "SNLinkedIn.h"
#import "SNPinterest.h"
#import "SNSms.h"
#import "SNTwitter.h"

@interface SNViewController()<UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) id<SNServiceProtocol> sharerEmail;
@property (strong, nonatomic) id<SNServiceProtocol> sharerSMS;
@property (strong, nonatomic) id<SNServiceProtocol> sharerFacebook;
@property (strong, nonatomic) id<SNServiceProtocol> sharerTwitter;
@property (strong, nonatomic) id<SNServiceProtocol> sharerInstagram;
@property (strong, nonatomic) id<SNServiceProtocol> sharerGooglePlus;
@property (strong, nonatomic) id<SNServiceProtocol> sharerLinkedIn;
@property (strong, nonatomic) id<SNServiceProtocol> sharerPinterest;
@property (strong, nonatomic) id<SNServiceProtocol> sharerGooglePlusAPI;

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
@property (weak, nonatomic) IBOutlet UIButton *shareViaGooglePlusAPI;

@property (nonatomic, copy) void (^shareCompletionHandler)(SNShareResult result, NSString* error);
@property (nonatomic, copy) void (^profileCompletionHandler)(SNShareResult result, NSDictionary* profile, NSString* error);

@end

@implementation SNViewController

static NSString* const googlePlusClientID = @"11030147974-93rf3gj3vapmr7k5nhssm9evb1ud3ris.apps.googleusercontent.com";
static NSString* const googlePlusClientSecret = @"5R4bRoYZFiGtpZyChbS-j0YV";
static NSString* const googlePlusRedirectUri = @"http://localhost";

static NSString* const linkedInApiKey = @"77o77yemk1co4x";
static NSString* const linkedInSecretKey = @"UKLNKYM7kslt9STZ";
static NSString* const linkedInRedirectUrl = @"http://helpbook.com";

static NSString* const pinterestClientId = @"1438963";

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.urlView.delegate = self;
    self.textView.delegate = self;
    
    self.shareViaEmail.enabled = [SNEmail isAvailable];
    self.shareViaSMS.enabled = [SNSms isAvailable];
    self.shareViaFacebook.enabled = [SNFacebook isAvailable];
    self.shareViaTwitter.enabled = [SNTwitter isAvailable];
    self.shareViaInstagram.enabled = [SNInstagram isAvailable];
    self.shareViaGooglePlus.enabled = [SNGooglePlus isAvailable];
    self.shareViaLinkedIn.enabled = [SNLinkedIn isAvailable];
    self.shareViaPinterest.enabled = [SNPinterest isAvailable];
    self.shareViaGooglePlusAPI.enabled = [SNGooglePlusAPI isAvailable];

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
    self.sharerGooglePlusAPI = [[SNGooglePlusAPI alloc] initWithParentViewControlller:self
                                                                             clientId:googlePlusClientID
                                                                         clientSecret:googlePlusClientSecret
                                                                          redirectUri:googlePlusRedirectUri];
    

    self.shareCompletionHandler = ^(SNShareResult result, NSString* error)
    {
        switch(result)
        {
            case SNShareResultDone:
            {
                [[[UIAlertView alloc] initWithTitle:@"Sharing done"
                                            message:@"You shared info successfully"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                break;
            }
            case SNShareResultCancelled:
            {
                [[[UIAlertView alloc] initWithTitle:@"Sharing cancelled"
                                            message:@"You cancelled sharing"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                break;
            }
            case SNShareResultFailed:
            {
                [[[UIAlertView alloc] initWithTitle:@"Sharing failed"
                                            message:error
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
    
    self.profileCompletionHandler = ^(SNShareResult result, NSDictionary* profile, NSString* error)
    {
        switch(result)
        {
            case SNShareResultDone:
            {
                [[[UIAlertView alloc] initWithTitle:@"Profile retrieved"
                                            message:[profile description]
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                break;
            }
            case SNShareResultCancelled:
            {
                [[[UIAlertView alloc] initWithTitle:@"Profile retrieving cancelled"
                                            message:error
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                break;
            }
            case SNShareResultFailed:
            {
                [[[UIAlertView alloc] initWithTitle:@"Profile retrieving failed"
                                            message:error
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                break;
            }
            case SNShareResultNotSupported:
            {
                [[[UIAlertView alloc] initWithTitle:@"Profile retrieving not supported"
                                            message:error
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
                   completionHandler:self.shareCompletionHandler];
    [self.sharerEmail retrieveProfileWithCompletionHandler:self.profileCompletionHandler];
}

- (IBAction)shareViaSMS:(id)sender
{
    [self.sharerSMS shareWithTitle:nil
                              text:self.textView.text
                               url:self.urlView.text
                             image:self.imageView.image
                 completionHandler:self.shareCompletionHandler];
    [self.sharerSMS retrieveProfileWithCompletionHandler:self.profileCompletionHandler];
}

- (IBAction)shareViaFacebook:(id)sender
{
    [self.sharerFacebook shareWithTitle:nil
                                   text:self.textView.text
                                    url:self.urlView.text
                                  image:self.imageView.image
                      completionHandler:self.shareCompletionHandler];
    [self.sharerFacebook retrieveProfileWithCompletionHandler:self.profileCompletionHandler];
}

- (IBAction)shareViaTwitter:(id)sender
{
    [self.sharerTwitter shareWithTitle:nil
                                  text:self.textView.text
                                   url:self.urlView.text
                                 image:self.imageView.image
                     completionHandler:self.shareCompletionHandler];
    [self.sharerTwitter retrieveProfileWithCompletionHandler:self.profileCompletionHandler];
}

- (IBAction)shareViaInstagram:(id)sender
{
    [self.sharerInstagram shareWithTitle:nil
                                    text:self.textView.text
                                     url:self.urlView.text
                                   image:self.imageView.image
                       completionHandler:self.shareCompletionHandler];
    [self.sharerInstagram retrieveProfileWithCompletionHandler:self.profileCompletionHandler];
}

- (IBAction)shareViaGooglePlus:(id)sender
{
    [self.sharerGooglePlus shareWithTitle:nil
                                     text:self.textView.text
                                      url:self.urlView.text
                                    image:self.imageView.image
                        completionHandler:self.shareCompletionHandler];
    [self.sharerGooglePlus retrieveProfileWithCompletionHandler:self.profileCompletionHandler];
}

- (IBAction)shareViaLinkedIn:(id)sender
{
    [self.sharerLinkedIn shareWithTitle:nil
                                   text:self.textView.text
                                    url:self.urlView.text
                               imageUrl:@"http://www.helpbook.com/images/logo_header.png"
                      completionHandler:self.shareCompletionHandler];
    [self.sharerLinkedIn retrieveProfileWithCompletionHandler:self.profileCompletionHandler];
}

- (IBAction)shareViaPinterest:(id)sender
{
    [self.sharerPinterest shareWithTitle:nil
                                    text:self.textView.text
                                     url:self.urlView.text
                                imageUrl:@"http://www.helpbook.com/images/logo_header.png"
                       completionHandler:self.shareCompletionHandler];
    [self.sharerPinterest retrieveProfileWithCompletionHandler:self.profileCompletionHandler];
}

- (IBAction)shareViaGooglePlusAPI:(id)sender
{
    [self.sharerGooglePlusAPI shareWithTitle:nil
                                        text:self.textView.text
                                         url:self.urlView.text
                                    imageUrl:@"http://www.helpbook.com/images/logo_header.png"
                           completionHandler:self.shareCompletionHandler];
    [self.sharerGooglePlusAPI retrieveProfileWithCompletionHandler:self.profileCompletionHandler];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqual:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
