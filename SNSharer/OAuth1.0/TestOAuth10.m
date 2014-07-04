//
//  TestOAuth10.m
//  SNSharer
//
//  Created by Rushad on 7/2/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "OAuth10.h"

#import <XCTest/XCTest.h>

@interface TestOAuth10 : XCTestCase

@end

@implementation TestOAuth10

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSignText
{
    NSString* sign = [OAuth10 signText:@"GET&http%3A%2F%2Fphotos.example.net%2Fphotos&file%3Dvacation.jpg%26oauth_consumer_key%3Ddpf43f3p2l4k3l03%26oauth_nonce%3Dkllo9940pd9333jh%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1191242096%26oauth_token%3Dnnch734d00sl2jdk%26oauth_version%3D1.0%26size%3Doriginal"
                        consumerSecret:@"kd94hf93k423kf44"
                           tokenSecret:@"pfkkdhi9sl3r4s00"];
    
    XCTAssertEqualObjects(@"tR3+Ty81lMeYAr/Fid0kMTYa/WM=", sign);
}

- (void)testSignatureBaseString
{
    NSDictionary* parameters = @{ @"key1" : @"value1",
                                  @"key2" : @"value2" };
    
    NSString* res = [OAuth10 signatureBaseStringMethod:@"GET"
                                                   url:@"http://example.com/query"
                                            parameters:parameters];
    
    XCTAssertEqualObjects(@"GET&http%3A%2F%2Fexample.com%2Fquery&key1%3Dvalue1%26key2%3Dvalue2", res);
}

- (void)testStringOfParameters
{
    NSDictionary* parameters = @{ @"key1" : @"value1",
                                  @"key2" : @"value2" };
    
    NSString* string = [OAuth10 stringOfParameters:parameters];
    
    XCTAssertEqualObjects(@"key1=value1&key2=value2", string);
}

- (void)testDictionaryFromURLParametersString
{
    NSDictionary* dict = [OAuth10 dictionaryFromURLParametersString:@"key1=value1&key2=value2"];
    
    XCTAssertEqualObjects(@"value2", [dict valueForKey:@"key2"]);
}

@end
