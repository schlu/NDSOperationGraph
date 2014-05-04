//
//  NDSGraphOperation.m
//  NDSOperationGraphExample
//
//  Created by Nicholas Schlueter on 5/3/14.
//  Copyright (c) 2014 2 Limes. All rights reserved.
//

#import "NDSGraphOperationBase.h"
#import "NDSOperationGraph.h"

@interface NDSGraphOperationBase () {
    BOOL _isExecuting;
    BOOL _isFinished;
}

@property (nonatomic, strong) NSMutableArray *dependantOperations;

@end

@implementation NDSGraphOperationBase

- (instancetype) init {
    if (self = [super init]) {
        _isExecuting = NO;
        _isFinished = NO;
    }
    return self;
}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isExecuting {
    return _isExecuting;
}

- (BOOL)isFinished {
    return _isFinished;
}

- (void)start {
    if (![self isCancelled]) {
        [self notifyStart];
        [self operationWork];
    } else {
        [self finish];
    }
}

- (void)operationWork {
    
}

- (void) notifyStart {
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _isExecuting = YES;
    _isFinished = NO;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)finishSuccessWith:(id)object {
    if (self.graph.operationSuccessBlock) {
        self.graph.operationSuccessBlock(self, object);
    }
    [self finish];
}

- (void)finishFailureWith:(NSError *)error object:(id)object {
    [self.graph operationFailure:self error:error object:object];
    [self finish];
}

- (void) finish {
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _isExecuting = NO;
    _isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    self.dependantOperations = nil;
}

@end
