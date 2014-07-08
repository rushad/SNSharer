//
//  TestOAuth20.m
//  SNSharer
//
//  Created by Rushad on 7/7/14.
//  Copyright (c) 2014 Rushad. All rights reserved.
//

#import "OAuth20.h"

#import <XCTest/XCTest.h>

@interface TestOAuth20 : XCTestCase

@end

@implementation TestOAuth20

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

- (void)testStringOfParameters
{
    NSDictionary* parameters = @{ @"key1" : @"value1",
                                  @"key2" : @"value2" };
    
    NSString* string = [OAuth20 stringOfParameters:parameters];
    
    XCTAssertEqualObjects(@"key1=value1&key2=value2", string);
}

- (void)testGetPathOfUrl
{
    XCTAssertNil([OAuth20 getPathOfUrl:nil]);
    
    XCTAssertEqualObjects(@"http://example.com/query", [OAuth20 getPathOfUrl:@"http://example.com/query?par1=val1&par1=val2"]);
    
    XCTAssertEqualObjects(@"http://example.com", [OAuth20 getPathOfUrl:@"http://example.com/?par1=val1&par1=val2"]);
}

- (void)testGetParametersOfUrl
{
    XCTAssertNil([OAuth20 getParametersOfUrl:nil]);
    
    XCTAssertNil([OAuth20 getParametersOfUrl:@""]);
    
    XCTAssertNil([OAuth20 getParametersOfUrl:@"http://example.com/query"]);

    NSDictionary* model = @{ @"key1" : @"val1",
                             @"key2" : @"val2" };
    NSDictionary* parameters = [OAuth20 getParametersOfUrl:@"http://example.com/query?key1=val1&key2=val2"];
    
    XCTAssertEqualObjects(model, parameters);
}

@end
