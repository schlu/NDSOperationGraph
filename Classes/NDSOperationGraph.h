//
//  NDSOperationGraph.h
//  NDSOperationGraphExample
//
//  Created by Nicholas Schlueter on 5/3/14.
//  Copyright (c) 2014 2 Limes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NDSGraphOperationBase.h"

typedef void (^NDSGraphOperationSuccessBlock)(NDSGraphOperationBase *operation, id object);
typedef void (^NDSGraphSuccessBlock)(void);
typedef void (^NDSGraphFailureBlock)(NDSGraphOperationBase *operation, NSError *error, id errorObject);

@interface NDSOperationGraph : NSObject

@property (nonatomic, copy) NDSGraphOperationSuccessBlock operationSuccessBlock;
@property (nonatomic, copy) NDSGraphSuccessBlock successBlock;
@property (nonatomic, copy) NDSGraphFailureBlock failureBlock;

- (void)operationOfType:(Class)class1 dependsOn:(Class)class2;
- (void)addOperations:(NSArray *)operations;
- (void)addOperation:(NDSGraphOperationBase *)operation;
- (void)startOperationsOnOperationQueue:(NSOperationQueue *)operationQueue;

- (void)operationFailure:(NDSGraphOperationBase *)operation error:(NSError *)error object:(id)object;

@end
