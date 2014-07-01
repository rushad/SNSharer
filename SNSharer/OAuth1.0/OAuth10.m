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

@interface OAuth10()

@property (strong, nonatomic) NSString* urlRequestToken;
@property (strong, nonatomic) NSString* urlAutorize;
@property (strong, nonatomic) NSString* urlAccessToken;
@property (strong, nonatomic) NSString* consumerKey;
@property (strong, nonatomic) NSString* signature;

@end

@implementation OAuth10

- (instancetype)initWithRequestTokenURL:(NSString *)urlRequestToken
                           authorizeURL:(NSString *)urlAuthorize
                         accessTokenURL:(NSString *)urlAccesToken
                            consumerKey:(NSString *)consumerKey
                              signature:(NSString *)signature
{
    self = [super init];
    if (self)
    {
        _urlRequestToken = urlRequestToken;
        _urlAutorize = urlAuthorize;
        _urlAccessToken = urlAccesToken;
        _consumerKey = consumerKey;
        _signature = signature;
    }
    return self;
}

+ (NSString*)URLEncodeString:(NSString*)src
{
    NSString *res = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)src,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8));
    return res;
}

- (NSString*)signText:(NSString*)text
           withSecret:(NSString*)secret
{
    unsigned char sha1[CC_SHA1_DIGEST_LENGTH];

    NSData* bufSecret = [secret dataUsingEncoding:NSUTF8StringEncoding];
    NSData* bufText = [text dataUsingEncoding:NSUTF8StringEncoding];
    
	CCHmac(kCCHmacAlgSHA1, [bufSecret bytes], [bufSecret length], [bufText bytes], [bufText length], sha1);
    
    const size_t base64len = ((CC_SHA1_DIGEST_LENGTH+2)/3)*4;
    char base64[base64len];
    size_t resultLen = base64len;
    
    Base64EncodeData(sha1, CC_SHA1_DIGEST_LENGTH, base64, &resultLen);
    
    NSData* data = [NSData dataWithBytes:base64 length:resultLen];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString*)signatureBaseStringUrl:(NSString*)url parameters:(NSDictionary*)parameters
{
    NSMutableArray* arrayParameters = [[NSMutableArray alloc] init];
    for (NSString* parameterName in [[parameters allKeys] sortedArrayUsingSelector:@selector(compare:)])
    {
        NSMutableString* strParameter = [NSMutableString stringWithString:[self.class URLEncodeString:parameterName]];
        [strParameter appendString:@"="];
        [strParameter appendString:[self.class URLEncodeString:[parameters valueForKey:parameterName]]];
        [arrayParameters addObject:strParameter];
    }
    NSLog(@"%@", [arrayParameters componentsJoinedByString:@"&"]);
    return @"test";
}

- (void)authorize
{
    NSDictionary* parameters = @{ @"oauth_consumer_key" : self.consumerKey,
                                  @"oauth_timestamp" : @"123 test&ing?",
                                  @"oauth_signature_method" : @"HMAC_SHA1" };
    NSLog(@"%@", [self signatureBaseStringUrl:[self urlRequestToken]
                                   parameters:parameters]);
}

@end
