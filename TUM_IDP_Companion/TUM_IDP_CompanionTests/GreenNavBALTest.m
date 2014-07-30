//
//  GreenNavBALTest.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 31/07/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GreenNavBAL.h"

@interface GreenNavBALTest : XCTestCase {

    GreenNavBAL *_greenNavBal;

}

@end

@implementation GreenNavBALTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _greenNavBal = [GreenNavBAL new];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNearestVertice {
    //    long latitude = 48.23;
    //    long longitude = 11.68;
    NSDictionary *params = @{@"latitude": @(48.23), @"longitude": @(11.68)};
    [_greenNavBal sendRequestForNearestVertice:params handler:^(id response, NSError *error) {
        
        NSAssert((response != nil), [response description]);
    }];
}

- (void)testVehicles {
    
    [_greenNavBal sendRequestForVehicles:^(id response, NSError *error) {
        NSAssert((response != nil), [response description]);
    }];
    
}

- (void)testVehiclesType {
    
    NSString *type = @"Sam";
    id params = type;
    [_greenNavBal sendRequestForVehiclesType:params handler:^(id response, NSError *error) {
        NSAssert((response != nil), [response description]);
    }];
}

- (void)testVehicleRoutes {
    
    NSString *type = @"Sam";
    long long toRoute = 188633982600;
    long long forRoute = 182440800;
    NSString *optimization = @"energy";
    NSUInteger battery = 100;

    NSDictionary *params = @{ type : @"type",
                              @(toRoute) : @"toRoute",
                              @(forRoute) : @"forRoute",
                              optimization : @"optimization",
                              @(battery) : @"battery" };
    [_greenNavBal sendRequestForVehicleRoutes:params handler:^(id response, NSError *error) {
        NSAssert((response != nil), [response description]);
    }];
    
}
- (void)testVehicleRange {

    NSString *type = @"Sam";
    long long range = 188633982600;
    NSUInteger battery = 100;
    
    NSDictionary *params = @{ type : @"type",
                              @(range) : @"range",
                              @(battery) : @"battery" };
    [_greenNavBal sendRequestForVehicleRange:params handler:^(id response, NSError *error) {
        NSAssert((response != nil), [response description]);
    }];
    
}
@end
