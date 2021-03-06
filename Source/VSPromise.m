//
//  VSPromise.m
//  VSPromise
//
//  Created by Viacheslav Soroka on 4/6/17.
//
//

#import "VSPromise.h"

typedef void(^VSCallback)(void);

typedef NS_ENUM(uint8_t, PRState) {
    PRStateDefault = 0,
    PRStateResolved,
    PRStateRejected
};

@interface VSPromise ()
@property (nonatomic, assign) PRState state;
@property (nonatomic, strong) NSMutableArray<VSCallback> *callbacks;

@property (nonatomic, strong) id result;
@property (nonatomic, strong) NSError *error;

@end

@implementation VSPromise

@dynamic resolved;
@dynamic rejected;

#pragma mark - Class Methods

+ (instancetype)promise
{
    return [self new];
}

+ (instancetype)resolved:(id)data
{
    return [[self promise] resolve:data];
}

+ (instancetype)rejected:(NSError *)error
{
    return [[self promise] reject:error];
}

+ (VSPromise *)combineAny:(NSArray<VSPromise *> *)promises
{
    return [self combinePromises:promises rejectOnFail:NO];
}

+ (VSPromise *)combineResolved:(NSArray<VSPromise *> *)promises
{
    return [self combinePromises:promises rejectOnFail:YES];
}

#pragma mark - Initializations and Deallocation

- (instancetype)init
{
    if (self = [super init]) {
        self.callbacks = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - Accessors

- (BOOL)resolved
{
    return self.state == PRStateResolved;
}

- (BOOL)rejected
{
    return self.state == PRStateRejected;
}

#pragma mark - Public Methods

- (VSPromise *)resolve:(id)data
{
    self.result = data;
    [self updateState:PRStateResolved];
    
    return self;
}

- (VSPromise *)reject:(NSError *)error
{
    self.error = error;
    [self updateState:PRStateRejected];
    
    return self;
}

- (VSPromiseReturnBlock)then
{
    return ^(id block){
        VSPromise *container = [VSPromise promise];
        id copyBlock = [block copy];
        
        [self processBlock:^{
            if (self.resolved) {
                VSPromise *realPromise = ((VSPromise *(^)(id))copyBlock)(self.result);
                if (realPromise) {
                    [realPromise processBlock:^{
                        if (realPromise.resolved) {
                            [container resolve:realPromise.result];
                        }
                        else if (realPromise.rejected) {
                            [container reject:realPromise.error];
                        }
                    }];
                }
                else {
                    [container resolve:self.result];
                }
            }
            else if (self.rejected) {
                [container reject:self.error];
            }
        }];
        
        return container;
    };
}

- (VSPromiseReturnBlock)fail
{
    return ^(id block){
        VSPromise *container = [VSPromise promise];
        id copyBlock = [block copy];
        
        [self processBlock:^{
            if (self.rejected) {
                VSPromise *realPromise = ((VSPromise *(^)(id))copyBlock)(self.error);
                if (realPromise) {
                    [realPromise processBlock:^{
                        if (realPromise.rejected) {
                            [container reject:realPromise.error];
                        }
                        else if (realPromise.resolved) {
                            [container resolve:realPromise.result];
                        }
                    }];
                }
                else {
                    [container reject:self.error];
                }
            }
            else if (self.resolved) {
                [container resolve:self.result];
            }
        }];
        
        return container;
    };
}

- (VSFinalyPromiseReturnBlock)finaly
{
    return ^(id block){
        [self processBlock:block];
        
        return self;
    };
}

- (VSPromise *)map:(VSTransformBlock)transform
{
    return self.then(^(id result) {
        return [[VSPromise promise] resolve:(transform ? transform(result) : result)];
    });
}

#pragma mark - Private Methods

+ (VSPromise *)combinePromises:(NSArray<VSPromise *> *)promises rejectOnFail:(BOOL)rejectOnFail
{
    NSObject *lockObject = [NSObject new];
    dispatch_group_t group = dispatch_group_create();
    for (NSInteger index = 0; index < promises.count; index++) {
        dispatch_group_enter(group);
    }
    
    VSPromise *result = [VSPromise promise];
    __block BOOL failed = NO;
    for (VSPromise *promise in promises) {
        promise.fail(^id(NSError *error) {
            @synchronized(lockObject) {
                if (rejectOnFail) {
                    failed = YES;
                    [result reject:nil];
                }
            }
            
            return nil;
        })
        .finaly(^{
            dispatch_group_leave(group);
        });
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (!failed) {
            [result resolve:nil];
        }
    });
    
    return result;
}

- (void)processBlock:(VSCallback)block
{
    @synchronized (self) {
        if (self.state == PRStateDefault) {
            [self.callbacks addObject:block];
        }
        else {
            [self performBlock:block];
        }
    }
}

- (void)performBlock:(VSCallback)block
{
    block();
}

- (void)updateState:(PRState)state
{
    void(^process)(void) = ^{
        NSArray<VSCallback> *callbacks = nil;
        
        @synchronized (self) {
            if (self.state == PRStateDefault) {
                self.state = state;
                
                callbacks = self.callbacks;
                
                self.callbacks = nil;
            }
        }
        
        for (VSCallback callback in callbacks) {
            [self performBlock:callback];
        }
    };
    
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            process();
        });
    }
    else {
        process();
    }
}

@end
