//
//  OAuth10.m
//  SNSharer
//
//  Created by Rushad on 7/1/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "OAuth10.h"

#import "Base64/Base64Transcoder.h"

#import <CommonCrypto/CommonHMAC.h>

@interface OAuth10()<UIWebViewDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSString* urlRequestToken;
@property (strong, nonatomic) NSString* urlAutorize;
@property (strong, nonatomic) NSString* urlAccessToken;
@property (strong, nonatomic) NSString* urlSubmitted;
@property (strong, nonatomic) NSString* jsGettingAccessToken;
@property (strong, nonatomic) NSString* consumerKey;
@property (strong, nonatomic) NSString* signature;

@property (strong, nonatomic) NSString* requestToken;
@property (strong, nonatomic) NSString* requestTokenSecret;
@property (strong, nonatomic) NSString* verifier;
@property (strong, nonatomic) NSString* accessToken;
@property (strong, nonatomic) NSString* accessTokenSecret;

@property (weak, nonatomic) UIViewController* parentViewController;

@end

@implementation OAuth10

- (instancetype)initWithRequestTokenURL:(NSString*)urlRequestToken
                           authorizeURL:(NSString*)urlAuthorize
                         accessTokenURL:(NSString*)urlAccesToken
                           submittedURL:(NSString*)urlSubmitted
                   jsGettingAccessToken:(NSString*)jsGettingAccessToken
                            consumerKey:(NSString*)consumerKey
                              signature:(NSString*)signature
                   parentViewController:(UIViewController*)parentViewController
{
    self = [super init];
    if (self)
    {
        _urlRequestToken = urlRequestToken;
        _urlAutorize = urlAuthorize;
        _urlAccessToken = urlAccesToken;
        _urlSubmitted = urlSubmitted;
        _jsGettingAccessToken = jsGettingAccessToken;
        _consumerKey = consumerKey;
        _signature = signature;
        _parentViewController = parentViewController;
    }
    return self;
}

+ (NSString*)URLEncodeString:(NSString*)string
{
    NSString *res = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)string,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8));
    return res;
}

+ (NSString*)signatureBaseStringUrl:(NSString*)url parameters:(NSDictionary*)parameters
{
    NSMutableArray* arrayParameters = [[NSMutableArray alloc] init];

    for (NSString* parameterName in [[parameters allKeys] sortedArrayUsingSelector:@selector(compare:)])
    {
        NSMutableString* strParameter = [NSMutableString stringWithString:parameterName];
        [strParameter appendString:@"="];
        [strParameter appendString:[parameters valueForKey:parameterName]];
        [arrayParameters addObject:strParameter];
    }

    NSString* res = [NSString stringWithFormat:@"%@&%@&%@", @"GET", [OAuth10 URLEncodeString:url],
                     [OAuth10 URLEncodeString:[arrayParameters componentsJoinedByString:@"&"]]];
                     
    return res;
}

+ (NSString*)signText:(NSString*)text
       consumerSecret:(NSString*)consumerSecret
          tokenSecret:(NSString*)tokenSecret
{
    NSString* secret = [NSString stringWithFormat:@"%@&%@",
                        [OAuth10 URLEncodeString:consumerSecret],
                        [OAuth10 URLEncodeString:tokenSecret]];
    
    unsigned char sha1[CC_SHA1_DIGEST_LENGTH];
    
    NSData* bufSecret = [secret dataUsingEncoding:NSUTF8StringEncoding];
    NSData* bufText = [text dataUsingEncoding:NSUTF8StringEncoding];
    
	CCHmac(kCCHmacAlgSHA1, [bufSecret bytes], [bufSecret length], [bufText bytes], [bufText length], sha1);
    
    const size_t base64len = ((CC_SHA1_DIGEST_LENGTH+2)/3)*4;
    char base64[base64len];
    size_t resultLen = base64len;
    
    Base64EncodeData(sha1, CC_SHA1_DIGEST_LENGTH, base64, &resultLen);
    
    NSString* sign = [[NSString alloc] initWithData:[NSData dataWithBytes:base64 length:resultLen] encoding:NSUTF8StringEncoding];

    return sign;
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

+ (NSDictionary*)dictionaryFromURLParametersString:(NSString*)string
{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] init];

    NSArray* arrayParameters = [string componentsSeparatedByString:@"&"];
    
    for (NSString* strParameter in arrayParameters)
    {
        NSArray* parameter = [strParameter componentsSeparatedByString:@"="];
        [parameters setValue:parameter[1] forKey:parameter[0]];
    }
    
    return parameters;
}

- (NSString*)timestamp
{
    return [NSString stringWithFormat:@"%ld", time(0)];
}

- (NSString*)nonce
{
    return [NSString stringWithFormat:@"%ld", random()];
}

- (BOOL)getAuthToken
{
    NSDictionary* queryParameters = @{ @"oauth_consumer_key" : self.consumerKey,
                                  @"oauth_signature_method" : @"HMAC-SHA1",
                                  @"oauth_callback" : @"oob",
                                  @"oauth_timestamp" : [self timestamp],
                                  @"oauth_nonce" : [self nonce] };
    
    NSString* signatureBaseString = [self.class signatureBaseStringUrl:self.urlRequestToken
                                                            parameters:queryParameters];
    
    NSString* sign = [self.class signText:signatureBaseString
                           consumerSecret:self.signature
                              tokenSecret:@""];
    
    NSString* queryRequestToken = [NSString stringWithFormat:@"%@?%@&oauth_signature=%@",
                                   self.urlRequestToken, [self.class stringOfParameters:queryParameters], [self.class URLEncodeString:sign]];
    
    NSString* response = [NSString stringWithContentsOfURL:[NSURL URLWithString:queryRequestToken] encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary* responseParameters = [self.class dictionaryFromURLParametersString:response];

    self.requestToken = [responseParameters valueForKey:@"oauth_token"];
    self.requestTokenSecret = [responseParameters valueForKey:@"oauth_token_secret"];

    return (self.requestToken && self.requestTokenSecret);
}

- (void)getVerifier
{
    NSString* strUrl = [self.urlAutorize stringByAppendingString:[NSString stringWithFormat:@"?oauth_token=%@", self.requestToken]];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]]];
    webView.delegate = self;
    
    UIViewController* webController = [[UIViewController alloc] init];
    webController.view = webView;
    webController.navigationItem.title = @"Authorization";
    
    UIViewController* rootController = [[UIViewController alloc] init];
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:rootController];
    [navigationController pushViewController:webController animated:YES];
    navigationController.delegate = self;
    
    [self.parentViewController presentViewController:navigationController animated:YES completion:nil];
}

- (void)retrieveAccessToken
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:
                                        @{ @"oauth_consumer_key" : self.consumerKey,
                                           @"oauth_token" : self.requestToken,
                                           @"oauth_signature_method" : @"HMAC-SHA1",
                                           @"oauth_timestamp" : [self timestamp],
                                           @"oauth_nonce" : [self nonce],
                                           @"oauth_verifier" : self.verifier } ];
    
    NSString* signatureBaseString = [self.class signatureBaseStringUrl:self.urlAccessToken
                                                            parameters:parameters];
    
    NSString* sign = [self.class signText:signatureBaseString
                           consumerSecret:self.signature
                              tokenSecret:self.requestTokenSecret];
    
    [parameters setValue:[self.class URLEncodeString:sign] forKey:@"oauth_signature"];
    
    NSString* queryAccessToken = [NSString stringWithFormat:@"%@?%@",
                                   self.urlAccessToken, [self.class stringOfParameters:parameters]];
    
    NSString* response = [NSString stringWithContentsOfURL:[NSURL URLWithString:queryAccessToken] encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary* responseParameters = [self.class dictionaryFromURLParametersString:response];
    
    self.accessToken = [responseParameters valueForKey:@"oauth_token"];
    self.accessTokenSecret = [responseParameters valueForKey:@"oauth_token_secret"];
}

- (void)authorize
{
    if ([self getAuthToken])
    {
        [self getVerifier];
    }
}

- (NSString*)getResourceByRequest:(NSString*)urlRequest
                       parameters:(NSDictionary*)requestParameters
{
    if (![self.accessToken length])
        return nil;
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:
                                        @{ @"oauth_consumer_key" : self.consumerKey,
                                           @"oauth_token" : self.accessToken,
                                           @"oauth_signature_method" : @"HMAC-SHA1",
                                           @"oauth_version" : @"1.0",
                                           @"oauth_timestamp" : [self timestamp],
                                           @"oauth_nonce" : [self nonce] } ];

    for (NSString* key in requestParameters)
    {
        [parameters setValue:[self.class URLEncodeString:[requestParameters valueForKey:key]] forKey:key];
    }
    
    
    NSString* signatureBaseString = [self.class signatureBaseStringUrl:urlRequest
                                                            parameters:parameters];
    
    NSLog(@"signatureBaseString: %@", signatureBaseString);
    
    NSString* sign = [self.class signText:signatureBaseString
                           consumerSecret:self.signature
                              tokenSecret:self.accessTokenSecret];
    
    [parameters setValue:[self.class URLEncodeString:sign] forKey:@"oauth_signature"];
    
    NSString* queryRequestToken = [NSString stringWithFormat:@"%@?%@",
                                   urlRequest, [self.class stringOfParameters:parameters]];
    
    NSLog(@"query: %@", queryRequestToken);
    
    NSString* response = [NSString stringWithContentsOfURL:[NSURL URLWithString:queryRequestToken] encoding:NSUTF8StringEncoding error:nil];

    return response;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
//    NSLog(@"UIWebView finished loading: %@", webView.request.URL.path);
    if ([webView.request.URL.path isEqualToString:self.urlSubmitted])
    {
        self.verifier = [webView stringByEvaluatingJavaScriptFromString:self.jsGettingAccessToken];
        if ([self.verifier length])
        {
            [self retrieveAccessToken];
        }
        if ([self.accessToken length])
        {
            [self.delegate accessGranted];
        }
        else
        {
            [self.delegate accessRefused];
        }
        
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    }
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
