//
//  VMSerivesRequestBALTest.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 31/07/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VMSerivesRequestBAL.h"

@interface VMSerivesRequestBALTest : XCTestCase {
    
    VMSerivesRequestBAL *_serviceRequestBAL;
}

@end

@implementation VMSerivesRequestBALTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _serviceRequestBAL = [VMSerivesRequestBAL new];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end
