//
//  NDSSampleOperationBase.m
//  NDSOperationGraphExample
//
//  Created by Nicholas Schlueter on 5/3/14.
//  Copyright (c) 2014 2 Limes. All rights reserved.
//

#import "NDSSampleOperationBase.h"

@implementation NDSSampleOperationBase

- (id)init {
    if (self = [super init]) {
        self.secondsToWait = 1;
        self.shouldFail = NO;
    }
    return self;
}

- (void)operationWork {
    __weak typeof(self) welf = self;
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * self.secondsToWait);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        if (welf.shouldFail) {
            NSLog(@"%@ did fail: thingToLog %@", welf, welf.thingToLog);
            [welf finishFailureWith:nil object:welf.thingToLog];
        } else {
            NSLog(@"%@ did succeed: thingToLog %@", welf, welf.thingToLog);
            [welf finishSuccessWith:welf.thingToLog];
        }
    });
}

@end
