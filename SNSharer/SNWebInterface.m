//
//  SNWebInterface.m
//  SNSharer
//
//  Created by Rushad on 6/23/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "SNWebInterface.h"

@interface SNWebInterface()<UINavigationControllerDelegate>

@property (strong, nonatomic) NSString* serviceName;
@property (strong, nonatomic) NSString* urlTemplate;
@property (strong, nonatomic) UIViewController* parentViewController;

@end

@implementation SNWebInterface

#pragma mark - Initializer

- (instancetype)initWithServiceName:(NSString*)serviceName
                        urlTemplate:(NSString*)urlTemplate
               parentViewController:(UIViewController *)parentViewController
{
    self = [super init];
    if (self)
    {
        _serviceName = serviceName;
        _urlTemplate = urlTemplate;
        _parentViewController = parentViewController;
    }
    return self;
}

#pragma mark - Share

- (void)shareText:(NSString *)text
              url:(NSString *)url
{
    NSString* sharerUrl = [NSString stringWithFormat:self.urlTemplate, text, url];
    sharerUrl = [sharerUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:sharerUrl]]];

    UIViewController* webController = [[UIViewController alloc] init];
    webController.view = webView;
    webController.navigationItem.title = self.serviceName;

    UIViewController* rootController = [[UIViewController alloc] init];
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:rootController];
    [navigationController pushViewController:webController animated:YES];
    navigationController.delegate = self;

    [self.parentViewController presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Delegates

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if (![viewController.view isKindOfClass:[UIWebView class]])
    {
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
