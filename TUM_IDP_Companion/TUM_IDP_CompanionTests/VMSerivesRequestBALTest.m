//
//  VMSerivesRequestBALTest.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 31/07/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VMServiceRequestBAL.h"

@interface VMSerivesRequestBALTest : XCTestCase {
    
    VMServiceRequestBAL *_serviceRequestBAL;
}

@end

static CGFloat TIME_OUT = 30;
@implementation VMSerivesRequestBALTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _serviceRequestBAL = [VMServiceRequestBAL new];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testVMServices {
   
    __block BOOL done = NO;
    
    [_serviceRequestBAL sendRequestForServices:^(id response, NSError *error) {
        
        XCTAssertTrue((response!= nil),
                      @" [response description] : %@", [response description] );
        done = YES;
    }];
    
    XCTAssertTrue([self waitFor:&done timeout:TIME_OUT],
                  @"Timed out waiting for response asynch method completion");
}

- (BOOL)waitFor:(BOOL *)flag timeout:(NSTimeInterval)timeoutSecs {
   
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSecs];
    
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        if ([timeoutDate timeIntervalSinceNow] < 0.0) {
            break;
        }
    }
    while (!*flag);
    return *flag;
}

@end
