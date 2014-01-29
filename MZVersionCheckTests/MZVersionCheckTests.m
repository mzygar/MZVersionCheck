//
//  MZVersionCheckTests.m
//  MZVersionCheckTests
//
//  Created by Michal Zygar on 29.01.2014.
//  Copyright (c) 2014 Michal Zygar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MZVersionCheck.h"
@interface MZVersionCheckTests : XCTestCase
{
    MZVersionCheck *_sut;
}
@end

@implementation MZVersionCheckTests

- (void)setUp
{
    [super setUp];
    _sut = [MZVersionCheck appstoreVersionCheck];
}

- (void)tearDown
{
    [super tearDown];
    _sut = nil;
}

- (void)testVersionComparsion
{
    XCTAssertTrue([self version:@"1.0.1" biggerThan:@"1.0"], @"");
    XCTAssertTrue([self version:@"1.1" biggerThan:@"1.0"], @"");
    XCTAssertTrue([self version:@"1.2.1" biggerThan:@"1.1"], @"");
    XCTAssertTrue([self version:@"1.0.12" biggerThan:@"1.0.2"], @"");
    XCTAssertTrue([self version:@"1.1.12.1" biggerThan:@"1.1.12"], @"");

    XCTAssertTrue([self version:@"2.0" biggerThan:@"1.9.3.99"], @"");
    XCTAssertTrue([self version:@"2.71" biggerThan:@"2.8"], @"");
}

- (void)testVersionsWithLetters
{
    XCTAssertTrue([self version:@"0.8b" biggerThan:@"0.7.1b"], @"");
    XCTAssertTrue([self version:@"1.1" biggerThan:@"1.0"], @"");
    XCTAssertTrue([self version:@"v1.1" biggerThan:@"v1.0"], @"");

    XCTAssertFalse([self version:@"0.7.1b" biggerThan:@"0.8b"], @"");
    XCTAssertFalse([self version:@"1.0a" biggerThan:@"1.0.1a"], @"");
    XCTAssertFalse([self version:@"v1.0" biggerThan:@"v1.1"], @"");
}

- (void)testVersionsWithLeadingZeros
{
    XCTAssertTrue([self version:@"2.012" biggerThan:@"2.011"], @"");
    XCTAssertTrue([self version:@"2.012" biggerThan:@"2.11"], @"");
}

- (void)testSameVersions
{
    XCTAssertTrue([self version:@"1.0.0" sameAs:@"1.0"], @"");
    XCTAssertTrue([self version:@"1.0.1.2" sameAs:@"1.0.1.2"], @"");
}

#pragma mark -
#pragma mark Helper methods
- (BOOL)version:(NSString *)ver1 biggerThan:(NSString *)ver2
{
    return [_sut compareVersion:ver1 toVersion:ver2] == NSOrderedDescending;
}

- (BOOL)version:(NSString *)ver1 smallerThan:(NSString *)ver2
{
    return [_sut compareVersion:ver1 toVersion:ver2] == NSOrderedAscending;
}

- (BOOL)version:(NSString *)ver1 sameAs:(NSString *)ver2
{
    return [_sut compareVersion:ver1 toVersion:ver2] == NSOrderedSame;
}

@end