//
//  NDSOperationGraph.m
//  NDSOperationGraphExample
//
//  Created by Nicholas Schlueter on 5/3/14.
//  Copyright (c) 2014 2 Limes. All rights reserved.
//

#import "NDSOperationGraph.h"

@interface NDSOperationGraph ()

@property (nonatomic, strong) NSMutableDictionary *dependencies;
@property (nonatomic, strong) NSMutableDictionary *operations;
@property (nonatomic, assign) BOOL operationError;

@end

@implementation NDSOperationGraph

- (instancetype)init {
    if (self = [super init]) {
        self.dependencies = [NSMutableDictionary dictionary];
        self.operations = [NSMutableDictionary dictionary];
        self.operationError = NO;
    }
    return self;
}

- (void)operationOfType:(Class)class1 dependsOn:(Class)class2 {
    NSMutableArray *classDependencies = self.dependencies[NSStringFromClass(class1)];
    if (!classDependencies) {
        classDependencies = [NSMutableArray array];
        self.dependencies[NSStringFromClass(class1)] = classDependencies;
    }
    [classDependencies addObject:NSStringFromClass(class2)];
}

- (void)addOperations:(NSArray *)operations {
    for (NDSGraphOperationBase *operation in operations) {
        operation.graph = self;
        [self addOperation:operation];
    }
}

- (void)addOperation:(NDSGraphOperationBase *)operation {
    NSMutableArray *operationsOfType = self.operations[NSStringFromClass([operation class])];
    if (!operationsOfType) {
        operationsOfType = [NSMutableArray array];
        self.operations[NSStringFromClass([operation class])] = operationsOfType;
    }
    [operationsOfType addObject:operation];
    NDSGraphOperationBase *localOperation = operation;
    __weak typeof(self) welf = self;
    operation.completionBlock = ^{
        [welf operationCompleted:localOperation];
    };
}

- (void)startOperationsOnOperationQueue:(NSOperationQueue *)operationQueue {
    for (NDSGraphOperationBase *operation in [self allOperations]) {
        [self setupDependenciesForOperation:operation withClasses:self.dependencies[NSStringFromClass([operation class])]];
    }
    [operationQueue addOperations:[self allOperations] waitUntilFinished:NO];
}

- (void)operationFailure:(NDSGraphOperationBase *)operation error:(NSError *)error object:(id)object {
    if (self.failureBlock) {
        self.failureBlock(operation, error, object);
    }
    for (NDSGraphOperationBase *operation in [self allOperations]) {
        [operation cancel];
    }
}

#pragma mark - internal

- (NSArray *)allOperations {
    NSMutableArray *allOperations = [NSMutableArray array];
    for (NSString *key in [self.operations keyEnumerator]) {
        for (NDSGraphOperationBase *operation in self.operations[key]) {
            [allOperations addObject:operation];
        }
    }
    return allOperations;
}

- (void)setupDependenciesForOperation:(NDSGraphOperationBase *)graphOperation withClasses:(NSArray *)classes {
    if (classes && [classes count] > 0) {
        BOOL foundDependency = NO;
        
        for (NSString *classString in classes) {
            for (NDSGraphOperationBase *operation in self.operations[classString]) {
                foundDependency = YES;
                [graphOperation addDependency:operation];
            }
        }
        
        if (!foundDependency) {
            [self setupDependenciesForOperation:graphOperation withClasses:[self dependencyClassesForClasses:classes]];
        }
    }
}

- (NSArray *)dependencyClassesForClasses:(NSArray *)classes {
    NSMutableArray *dependencies = [NSMutableArray array];
    
    for (NSString *classString in classes) {
        if (self.dependencies[classString]) {
            [dependencies addObjectsFromArray:self.dependencies[classString]];
        }
    }
    
    return dependencies;
}

- (void)operationCompleted:(NDSGraphOperationBase *)operation {
    NSMutableArray *operationsOfType = self.operations[NSStringFromClass([operation class])];
    [operationsOfType removeObject:operation];
    if ([operationsOfType count] == 0) {
        [self.operations removeObjectForKey:NSStringFromClass([operation class])];
        if ([self.operations count] == 0 && !self.operationError && self.successBlock) {
            self.successBlock();
        }
    }
}


@end
