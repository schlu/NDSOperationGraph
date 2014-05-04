//
//  NDSGraphOperation.h
//  NDSOperationGraphExample
//
//  Created by Nicholas Schlueter on 5/3/14.
//  Copyright (c) 2014 2 Limes. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NDSOperationGraph;

@interface NDSGraphOperationBase : NSOperation

@property (nonatomic, weak) NDSOperationGraph *graph;

- (void)finishSuccessWith:(id)object;
- (void)finishFailureWith:(NSError *)error object:(id)object;
- (void)operationWork;

@end
