//
//  VSPromiseProvider.m
//  VSPromise
//
//  Created by Viacheslav Soroka on 4/7/17.
//  Copyright © 2017 VS. All rights reserved.
//

#import "VSPromiseProvider.h"

#import "VSPromise.h"

static unsigned int const kSleep = 1;

@implementation VSPromiseProvider

#pragma mark - Public Methods

+ (VSPromise *)asyncSuccessPromise
{
    return [self asyncSuccessPromiseWithResult:nil];
}

+ (VSPromise *)asyncSuccessPromiseWithResult:(id)result
{
    VSPromise *promise = [VSPromise promise];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        sleep(kSleep);
        [promise resolve:result];
    });
    
    return promise;
}

+ (VSPromise *)asyncFailedPromise
{
    return [self asyncFailedPromiseWithError:nil];
}

+ (VSPromise *)asyncFailedPromiseWithError:(NSError *)error
{
    VSPromise *promise = [VSPromise promise];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        sleep(kSleep);
        [promise reject:error];
    });
    
    return promise;
}

+ (VSPromise *)syncSuccessPromise
{
    return [self syncSuccessPromiseWithResult:nil];
}

+ (VSPromise *)syncSuccessPromiseWithResult:(id)result
{
    return [[VSPromise promise] resolve:result];
}

+ (VSPromise *)syncFailedPromise
{
    return [self syncFailedPromiseWithError:nil];
}

+ (VSPromise *)syncFailedPromiseWithError:(NSError *)error
{
    return [[VSPromise promise] reject:error];
}


@end
