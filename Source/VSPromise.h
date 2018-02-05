//
//  VSPromise.h
//  VSPromise
//
//  Created by Viacheslav Soroka on 4/6/17.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class VSPromise;

typedef VSPromise * _Nullable (^VSPromiseReturnBlock)(id _Nullable (^)(id _Nullable));
typedef VSPromise * _Nullable (^VSFinalyPromiseReturnBlock)(void(^)(void));

typedef id _Nullable (^VSTransformBlock)(id data);

@interface VSPromise : NSObject
@property (nullable, nonatomic, readonly) id result;
@property (nullable, nonatomic, readonly) NSError *error;

@property (nonatomic, readonly) BOOL resolved;
@property (nonatomic, readonly) BOOL rejected;

+ (instancetype)promise;

/// @return Allready resolved promise.
+ (instancetype)resolved:(nullable id)data;

/// @return Allready rejected promise.
+ (instancetype)rejected:(nullable NSError *)error;

/** Attaches any block to all parameters.
 * @returns A promise which is resolved after after all promises performed. */
+ (VSPromise *)combineAny:(NSArray<VSPromise *> *)promises;

/** @warning If any promise fails, result promise will fail immediately.
 * @returns A promise which is resolved after after all promises resolved. */
+ (VSPromise *)combineResolved:(NSArray<VSPromise *> *)promises;

- (VSPromise *)resolve:(nullable id)data;
- (VSPromise *)reject:(nullable NSError *)error;

- (VSPromiseReturnBlock)then;
- (VSPromiseReturnBlock)fail;
- (VSFinalyPromiseReturnBlock)finaly;

- (VSPromise *)map:(VSTransformBlock)transform;

@end

NS_ASSUME_NONNULL_END

