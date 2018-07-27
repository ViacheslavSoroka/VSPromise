//
//  VSPromiseProvider.h
//  VSPromise
//
//  Created by Viacheslav Soroka on 4/7/17.
//  Copyright © 2017 VS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VSPromise;

@interface VSPromiseProvider : NSObject

+ (VSPromise *)asyncSuccessPromise;
+ (VSPromise *)asyncSuccessPromiseWithResult:(id)result;

+ (VSPromise *)asyncFailedPromise;
+ (VSPromise *)asyncFailedPromiseWithError:(NSError *)error;

+ (VSPromise *)syncSuccessPromise;
+ (VSPromise *)syncSuccessPromiseWithResult:(id)result;

+ (VSPromise *)syncFailedPromise;
+ (VSPromise *)syncFailedPromiseWithError:(NSError *)error;

@end
