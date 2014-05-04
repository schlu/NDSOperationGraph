//
//  NDSSampleOperationBase.h
//  NDSOperationGraphExample
//
//  Created by Nicholas Schlueter on 5/3/14.
//  Copyright (c) 2014 2 Limes. All rights reserved.
//

#import "NDSGraphOperationBase.h"

@interface NDSSampleOperationBase : NDSGraphOperationBase

@property (nonatomic, assign) NSInteger secondsToWait;
@property (nonatomic, assign) BOOL shouldFail;
@property (nonatomic, strong) NSString *thingToLog;

@end
