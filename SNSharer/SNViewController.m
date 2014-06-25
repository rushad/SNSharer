//
//  SNSViewController.m
//  SNSharer
//
//  Created by Rushad on 6/17/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNViewController.h"

#import "SNSharer.h"

@interface SNViewController ()

@property (nonatomic, strong) SNSharer* sharerEmail;
@property (nonatomic, strong) SNSharer* sharerSMS;
@property (nonatomic, strong) SNSharer* sharerFacebook;
@property (nonatomic, strong) SNSharer* sharerTwitter;
@property (nonatomic, strong) SNSharer* sharerInstagram;

@property (weak, nonatomic) IBOutlet UITextField *urlView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *shareViaEmail;
@property (weak, nonatomic) IBOutlet UIButton *shareViaSMS;
@property (weak, nonatomic) IBOutlet UIButton *shareViaFacebook;
@property (weak, nonatomic) IBOutlet UIButton *shareViaTwitter;
@property (weak, nonatomic) IBOutlet UIButton *shareViaInstagram;

@end

@implementation SNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sharerEmail = [[SNSharer alloc] initWithService:SERVICE_EMAIL parentViewController:self];
    self.sharerSMS = [[SNSharer alloc] initWithService:SERVICE_SMS parentViewController:self];
    self.sharerFacebook = [[SNSharer alloc] initWithService:SERVICE_FACEBOOK parentViewController:self];
    self.sharerTwitter = [[SNSharer alloc] initWithService:SERVICE_TWITTER parentViewController:self];
    self.sharerInstagram = [[SNSharer alloc] initWithService:SERVICE_INSTAGRAM parentViewController:self];
    
    self.shareViaEmail.enabled = (self.sharerEmail != nil);
    self.shareViaSMS.enabled = (self.sharerSMS != nil);
    self.shareViaFacebook.enabled = (self.sharerFacebook != nil);
    self.shareViaTwitter.enabled = (self.sharerTwitter != nil);
    self.shareViaInstagram.enabled = (self.sharerInstagram != nil);
}

- (IBAction)shareViaEmail:(id)sender
{
    [self.sharerEmail shareText:self.textView.text url:self.urlView.text image:self.imageView.image];
}

- (IBAction)shareViaSMS:(id)sender
{
    [self.sharerSMS shareText:self.textView.text url:self.urlView.text image:nil];
}

- (IBAction)shareViaFacebook:(id)sender
{
    [self.sharerFacebook shareText:self.textView.text url:self.urlView.text image:self.imageView.image];
}

- (IBAction)shareViaTwitter:(id)sender
{
    [self.sharerTwitter shareText:self.textView.text url:self.urlView.text image:self.imageView.image];
}

- (IBAction)shareViaInstagram:(id)sender
{
    [self.sharerInstagram shareText:self.textView.text url:self.urlView.text image:self.imageView.image];
}

@end
