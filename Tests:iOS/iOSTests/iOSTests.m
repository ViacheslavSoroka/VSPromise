//
//  iOSTests.m
//  iOSTests
//
//  Created by Viacheslav Soroka on 7/27/18.
//  Copyright © 2018 Viacheslav Soroka. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "VSPromise.h"
#import "VSPromiseProvider.h"

@interface iOSTests : XCTestCase

@end

@implementation iOSTests

#pragma mark - Tests

- (void)testAsyncSuccess
{
    XCTestExpectation *espectation = [self expectationWithDescription:@"testAsyncEspectation"];
    __block BOOL thenPerformed = NO;
    
    [VSPromiseProvider asyncSuccessPromiseWithResult:[NSObject new]].then(^id(id result) {
        XCTAssert(result);
        thenPerformed = YES;
        
        return nil;
    }).fail(^id(NSError *error) {
        XCTAssert(NO);
        
        return nil;
    }).finaly(^{
        XCTAssert(thenPerformed);
        
        [espectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:60 handler:nil];
}

@end
