//
//  OAuth20.m
//  SNSharer
//
//  Created by Rushad on 7/7/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "OAuth20.h"

@interface OAuth20()<UIWebViewDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSString* urlAuthorization;
@property (strong, nonatomic) NSString* urlAccessToken;
@property (strong, nonatomic) NSString* urlRedirect;

@property (strong, nonatomic) NSString* apiKey;
@property (strong, nonatomic) NSString* secretKey;

@property (strong, nonatomic) NSString* accessToken;

@property (weak, nonatomic) UIViewController* parentViewController;

@end

@implementation OAuth20

#pragma mark - Initializer

- (instancetype)initWithAuthorizationURL:(NSString*)urlAuthorization
                          accessTokenURL:(NSString*)urlAccessToken
                             redirectURL:(NSString*)urlRedirect
                                  apiKey:(NSString*)apiKey
                               secretKey:(NSString*)secretKey
                    parentViewController:(UIViewController*)parentViewController
{
    self = [super init];
    if (self)
    {
        _urlAuthorization = urlAuthorization;
        _urlAccessToken = urlAccessToken;
        _urlRedirect = urlRedirect;
        _apiKey = apiKey;
        _secretKey = secretKey;
        _parentViewController = parentViewController;
    }
    return self;
}

#pragma mark - Class methods

+ (NSString*)URLEncodeString:(NSString*)string
{
    NSString *res = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                          (CFStringRef)string,
                                                                                          NULL,
                                                                                          CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                          kCFStringEncodingUTF8));
    return res;
}

+ (NSString*)stringOfParameters:(NSDictionary*)parameters
{
    NSMutableArray* arrayParameters = [[NSMutableArray alloc] init];
    
    for (NSString* parameterName in [[parameters allKeys] sortedArrayUsingSelector:@selector(compare:)])
    {
        NSString* value = [parameters valueForKey:parameterName];
        NSString* strParameter = [NSString stringWithFormat:@"%@=%@", parameterName, value];
        [arrayParameters addObject:strParameter];
    }
    
    return [arrayParameters componentsJoinedByString:@"&"];
}

+ (NSString*)getPathOfUrl:(NSString*)url
{
    if (!url)
        return nil;
    
    NSString* res = [url componentsSeparatedByString:@"?"][0];
    if ([[res substringFromIndex:[res length] - 1] isEqualToString:@"/"])
        res = [res substringToIndex:[res length] - 1];
    
    return res;
}

/*
+ (NSDictionary*)dictionaryFromURLParametersString:(NSString*)string
{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] init];
    
    NSArray* arrayParameters = [string componentsSeparatedByString:@"&"];
    
    for (NSString* strParameter in arrayParameters)
    {
        NSArray* parameter = [strParameter componentsSeparatedByString:@"="];
        if ([parameter count] > 1)
            [parameters setValue:parameter[1] forKey:parameter[0]];
    }
    
    return parameters;
}
*/
#pragma mark - Private methods

- (void)getQuery:(NSString*)query
      completion:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:query]];
    request.HTTPMethod = @"GET";
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:handler];
}


#pragma mark - Public methods

- (void)authorizeWithScope:(NSString*)scope
                     state:(NSString*)state
{
    NSDictionary* parameters = @{ @"response_type" : @"code",
                                  @"client_id" : [OAuth20 URLEncodeString:self.apiKey],
                                  @"scope" : [OAuth20 URLEncodeString:scope],
                                  @"state" : [OAuth20 URLEncodeString:state],
                                  @"redirect_uri" : [OAuth20 URLEncodeString:self.urlRedirect] };
    
    NSString* query = [NSString stringWithFormat:@"%@?%@",
                       self.urlAuthorization, [self.class stringOfParameters:parameters]];

    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:query]]];
    webView.delegate = self;
    
    UIViewController* webController = [[UIViewController alloc] init];
    webController.view = webView;
    webController.navigationItem.title = @"Authorization";
    
    UIViewController* rootController = [[UIViewController alloc] init];
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:rootController];
    [navigationController pushViewController:webController animated:YES];
    navigationController.delegate = self;
    
    [self.parentViewController presentViewController:navigationController animated:NO completion:nil];
}

- (void)getResourceByQuery:(NSString*)urlQuery
                parameters:(NSDictionary*)parameters
                 onSuccess:(void (^)(NSString* body))onSuccessBlock
{
    
}

- (void)postResourceByQuery:(NSString*)urlQuery
           headerParameters:(NSDictionary*)headerParameters
                       body:(NSString*)body
                  onSuccess:(void (^)(NSString* body))onSuccessBlock
{
    
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* url = request.URL.absoluteString;
    
    if ([[self.class getPathOfUrl:url] isEqualToString:[self.class getPathOfUrl:self.urlRedirect]])
    {
        NSLog(@"%@", url);
//        NSLog(@"%@", [self.class dictionaryFromURLParametersString:parameters]);
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }
    
    return YES;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController*)navigationController
      willShowViewController:(UIViewController*)viewController
                    animated:(BOOL)animated
{
    if (![viewController.view isKindOfClass:[UIWebView class]])
    {
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
