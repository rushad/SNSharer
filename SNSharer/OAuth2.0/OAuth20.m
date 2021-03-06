//
//  OAuth20.m
//  SNSharer
//
//  Created by Rushad on 7/7/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "OAuth20.h"

#define WebKitErrorFrameLoadInterruptedByPolicyChange 102

@interface OAuth20()<UIWebViewDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSString* urlAuthorization;
@property (strong, nonatomic) NSString* urlAccessToken;
@property (strong, nonatomic) NSString* urlRedirect;

@property (strong, nonatomic) NSString* apiKey;
@property (strong, nonatomic) NSString* secretKey;

@property (strong, nonatomic) NSString* accessToken;

@property (weak, nonatomic) UIViewController* parentViewController;

@property (strong, nonatomic) NSString* scope;
@property (strong, nonatomic) NSString* state;
@property (nonatomic, copy) void (^authorizeCompletionHandler)(BOOL accessGranted, NSString* error, NSString* errorDescription);

@property (strong, nonatomic) UINavigationController* navigationController;

@end

@implementation OAuth20

static NSString* const GET = @"GET";
static NSString* const POST = @"POST";
static NSString* const response_type = @"response_type";
static NSString* const code = @"code";
static NSString* const client_id = @"client_id";
static NSString* const scope = @"scope";
static NSString* const state = @"state";
static NSString* const redirect_uri = @"redirect_uri";
static NSString* const grant_type = @"grant_type";
static NSString* const authorization_code = @"authorization_code";
static NSString* const client_secret = @"client_secret";
static NSString* const access_token = @"access_token";
static NSString* const error = @"error";
static NSString* const error_description = @"error_description";
static NSString* const oauth2_access_token = @"oauth2_access_token";

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

+ (NSDictionary*)getParametersOfUrl:(NSString *)url
{
    if (!url)
        return nil;
    
    NSArray* urlComponents = [url componentsSeparatedByString:@"?"];
    if (urlComponents.count != 2)
        return nil;
    
    NSString* strParameters = urlComponents[1];

    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] init];
    
    NSArray* arrayParameters = [strParameters componentsSeparatedByString:@"&"];
    
    for (NSString* strParameter in arrayParameters)
    {
        NSArray* parameter = [strParameter componentsSeparatedByString:@"="];
        if ([parameter count] > 1)
            [parameters setValue:parameter[1] forKey:parameter[0]];
    }
    
    return [NSDictionary dictionaryWithDictionary:parameters];
}

#pragma mark - Private methods

- (void)getQuery:(NSString*)query
      completion:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:query]];
    request.HTTPMethod = GET;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:handler];
}

- (void)postQuery:(NSString*)query
 headerParameters:(NSDictionary*)headerParameters
   bodyParameters:(NSDictionary*)bodyParameters
       completion:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    [self postQuery:query
   headerParameters:headerParameters
               body:[self.class stringOfParameters:bodyParameters]
         completion:handler];
}

- (void)postQuery:(NSString*)query
 headerParameters:(NSDictionary*)headerParameters
             body:(NSString*)body
       completion:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:query]];
    request.HTTPMethod = POST;
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    for (NSString* key in headerParameters)
    {
        [request setValue:[headerParameters valueForKey:key] forHTTPHeaderField:key];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:handler];
}

- (void)startRetrievingAuthCode
{
    NSDictionary* parameters = @{ response_type : code,
                                  client_id : [OAuth20 URLEncodeString:self.apiKey],
                                  scope : [OAuth20 URLEncodeString:self.scope],
                                  state : [OAuth20 URLEncodeString:self.state],
                                  redirect_uri : [OAuth20 URLEncodeString:self.urlRedirect] };
    
    NSString* query = [NSString stringWithFormat:@"%@?%@",
                       self.urlAuthorization, [self.class stringOfParameters:parameters]];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:query]]];
    webView.delegate = self;
    
    UIViewController* webController = [[UIViewController alloc] init];
    webController.view = webView;
    webController.navigationItem.title = @"Authorization";
    
    UIViewController* rootController = [[UIViewController alloc] init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:rootController];
    [self.navigationController pushViewController:webController animated:YES];
    self.navigationController.delegate = self;
    
    self.parentViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self.navigationController.view setHidden:YES];
    [self.parentViewController presentViewController:self.navigationController animated:NO completion:nil];
}

- (void)startRetrievingAccessTokenWithAuthCode:(NSString*)authCode
{
    NSDictionary* parameters = @{ grant_type : authorization_code,
                                  code : authCode,
                                  redirect_uri : [OAuth20 URLEncodeString:self.urlRedirect],
                                  client_id : [OAuth20 URLEncodeString:self.apiKey],
                                  client_secret : [OAuth20 URLEncodeString:self.secretKey] };
    
    [self postQuery:self.urlAccessToken
   headerParameters:nil
     bodyParameters:parameters
         completion:^(NSURLResponse* response, NSData* body, NSError* errorObj)
                     {
                         NSDictionary* json = [NSJSONSerialization JSONObjectWithData:body options:0 error:nil];
                         if (errorObj)
                         {
                             self.authorizeCompletionHandler(NO,
                                                             [NSString stringWithFormat:@"%d", errorObj.code],
                                                             errorObj.description);
                         }
                         else
                         {
                             self.accessToken = [json valueForKey:access_token];
                             self.authorizeCompletionHandler([self.accessToken length],
                                                             [json valueForKey:error],
                                                             [json valueForKey:error_description]);
                         }
                     }];
}

#pragma mark - Public methods

- (BOOL)isAuthorized
{
    return [self.accessToken length];
}

- (void)authorizeWithScope:(NSString*)scope
                     state:(NSString *)state
         completionHandler:(void (^)(BOOL, NSString*, NSString*))completionHandler
{
    self.scope = scope;
    self.state = state;
    self.authorizeCompletionHandler = completionHandler;
    
    [self startRetrievingAuthCode];
}

- (void)getResourceByQuery:(NSString*)urlQuery
                parameters:(NSDictionary*)requestParameters
         completionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))completionHandler
{
    if (![self.accessToken length])
        return;
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       @{ oauth2_access_token : self.accessToken }];
    
    for (NSString* key in requestParameters)
    {
        [parameters setValue:[self.class URLEncodeString:[requestParameters valueForKey:key]] forKey:key];
    }
    
    NSString* query = [NSString stringWithFormat:@"%@?%@",
                       urlQuery, [self.class stringOfParameters:parameters]];
    
    [self getQuery:query
        completion:completionHandler];
}

- (void)postResourceByQuery:(NSString*)urlQuery
           headerParameters:(NSDictionary*)headerParameters
                       body:(NSString*)body
          completionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))completionHandler
{
    if (![self.accessToken length])
        return;
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       @{ oauth2_access_token : self.accessToken }];
    
    NSString* query = [NSString stringWithFormat:@"%@?%@",
                       urlQuery, [self.class stringOfParameters:parameters]];
    
    [self postQuery:query
   headerParameters:headerParameters
               body:body
         completion:completionHandler];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* url = request.URL.absoluteString;
    if ([[self.class getPathOfUrl:url] isEqualToString:[self.class getPathOfUrl:self.urlRedirect]])
    {
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
        
        NSDictionary* parameters = [self.class getParametersOfUrl:url];
        NSString* stateValue = [parameters valueForKey:state];
        NSString* authCode = [parameters valueForKey:code];
        
        if ([stateValue isEqualToString:self.state] && [authCode length])
        {
            [self startRetrievingAccessTokenWithAuthCode:authCode];
        }
        else
        {
            self.authorizeCompletionHandler(NO,
                                            [parameters valueForKey:error],
                                            [parameters valueForKey:error_description]);
        }
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.navigationController.view.hidden = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (error.code  == WebKitErrorFrameLoadInterruptedByPolicyChange)
        return;
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    self.authorizeCompletionHandler(NO, [NSString stringWithFormat:@"%d", error.code], error.description);
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController*)navigationController
      willShowViewController:(UIViewController*)viewController
                    animated:(BOOL)animated
{
    if (![viewController.view isKindOfClass:[UIWebView class]])
    {
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
        self.authorizeCompletionHandler(NO, nil, @"Authorization cancelled by user");
    }
}

@end
