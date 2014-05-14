//
//  NDSViewController.m
//  NDSOperationGraphExample
//
//  Created by Nicholas Schlueter on 5/3/14.
//  Copyright (c) 2014 2 Limes. All rights reserved.
//

#import "NDSViewController.h"
#import "NDSOperationFoo.h"
#import "NDSOperationBar.h"
#import "NDSOperationBaz.h"
#import "NDSOperationZap.h"
#import "NDSOperationGraph.h"

@interface NDSViewController ()

@property (nonatomic, strong) NDSOperationGraph *graph;
@property (nonatomic, strong) NSOperationQueue *backgroundQueue;

@end

@implementation NDSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)graphSucceedsAction:(id)sender {
    self.graph = [[NDSOperationGraph alloc] init];
    [self.graph setSuccessBlock:^{
        NSLog(@"success finished");
    }];
    [self.graph operationOfType:[NDSOperationZap class] dependsOn:[NDSOperationFoo class]];
    NDSOperationZap *zap = [[NDSOperationZap alloc] init];
    zap.thingToLog = @"zap";
    NDSOperationFoo *foo1 = [[NDSOperationFoo alloc] init];
    foo1.thingToLog = @"foo 1";
    NDSOperationFoo *foo2 = [[NDSOperationFoo alloc] init];
    foo2.thingToLog = @"foo 2";
    NDSOperationFoo *foo3 = [[NDSOperationFoo alloc] init];
    foo3.thingToLog = @"foo 3";
    NDSOperationFoo *foo4 = [[NDSOperationFoo alloc] init];
    foo4.thingToLog = @"foo 4";
    NDSOperationFoo *foo5 = [[NDSOperationFoo alloc] init];
    foo5.thingToLog = @"foo 5";
    [self.graph addOperations:@[zap, foo1, foo2, foo3, foo4, foo5]];
    [self.graph startOperationsOnOperationQueue:[NSOperationQueue mainQueue]];
}

- (IBAction)graphFailsAction:(id)sender {
    self.graph = [[NDSOperationGraph alloc] init];
    [self.graph setFailureBlock:^(NDSGraphOperationBase *operation, NSError *error, id errorObject){
        NSLog(@"errorObject %@", errorObject);
    }];
    [self.graph operationOfType:[NDSOperationZap class] dependsOn:[NDSOperationFoo class]];
    NDSOperationZap *zap = [[NDSOperationZap alloc] init];
    zap.thingToLog = @"zap";
    NDSOperationFoo *foo1 = [[NDSOperationFoo alloc] init];
    foo1.thingToLog = @"foo 1";
    NDSOperationFoo *foo2 = [[NDSOperationFoo alloc] init];
    foo2.thingToLog = @"foo 2";
    NDSOperationFoo *foo3 = [[NDSOperationFoo alloc] init];
    foo3.thingToLog = @"foo 3";
    foo3.shouldFail = YES;
    NDSOperationFoo *foo4 = [[NDSOperationFoo alloc] init];
    foo4.thingToLog = @"foo 4";
    NDSOperationFoo *foo5 = [[NDSOperationFoo alloc] init];
    foo5.thingToLog = @"foo 5";
    [self.graph addOperations:@[zap, foo1, foo2, foo3, foo4, foo5]];
    [self.graph startOperationsOnOperationQueue:[NSOperationQueue mainQueue]];
}

- (IBAction)graphSucceedsMissingLayerAction:(id)sender {
    self.graph = [[NDSOperationGraph alloc] init];
    [self.graph setSuccessBlock:^{
        NSLog(@"success finished");
    }];
    [self.graph operationOfType:[NDSOperationBar class] dependsOn:[NDSOperationFoo class]];
    [self.graph operationOfType:[NDSOperationZap class] dependsOn:[NDSOperationBar class]];
    NDSOperationZap *zap = [[NDSOperationZap alloc] init];
    zap.thingToLog = @"zap";
    NDSOperationFoo *foo1 = [[NDSOperationFoo alloc] init];
    foo1.thingToLog = @"foo 1";
    NDSOperationFoo *foo2 = [[NDSOperationFoo alloc] init];
    foo2.thingToLog = @"foo 2";
    NDSOperationFoo *foo3 = [[NDSOperationFoo alloc] init];
    foo3.thingToLog = @"foo 3";
    NDSOperationFoo *foo4 = [[NDSOperationFoo alloc] init];
    foo4.thingToLog = @"foo 4";
    NDSOperationFoo *foo5 = [[NDSOperationFoo alloc] init];
    foo5.thingToLog = @"foo 5";
    [self.graph addOperations:@[zap, foo1, foo2, foo3, foo4, foo5]];
    self.backgroundQueue = [[NSOperationQueue alloc] init];
    [self.graph startOperationsOnOperationQueue:self.backgroundQueue];
}

- (IBAction)graphFailsMissingLayerAction:(id)sender {
    self.graph = [[NDSOperationGraph alloc] init];
    [self.graph setSuccessBlock:^{
        NSLog(@"never called");
    }];
    [self.graph setFailureBlock:^(NDSGraphOperationBase *operation, NSError *error, id errorObject){
        NSLog(@"errorObject %@", errorObject);
    }];
    [self.graph operationOfType:[NDSOperationBar class] dependsOn:[NDSOperationFoo class]];
    [self.graph operationOfType:[NDSOperationZap class] dependsOn:[NDSOperationBar class]];
    NDSOperationZap *zap = [[NDSOperationZap alloc] init];
    zap.thingToLog = @"zap";
    NDSOperationFoo *foo1 = [[NDSOperationFoo alloc] init];
    foo1.thingToLog = @"foo 1";
    NDSOperationFoo *foo2 = [[NDSOperationFoo alloc] init];
    foo2.thingToLog = @"foo 2";
    NDSOperationFoo *foo3 = [[NDSOperationFoo alloc] init];
    foo3.thingToLog = @"foo 3";
    NDSOperationFoo *foo4 = [[NDSOperationFoo alloc] init];
    foo4.thingToLog = @"foo 4";
    foo4.shouldFail = YES;
    NDSOperationFoo *foo5 = [[NDSOperationFoo alloc] init];
    foo5.thingToLog = @"foo 5";
    [self.graph addOperations:@[zap, foo1, foo2, foo3, foo4, foo5]];
    self.backgroundQueue = [[NSOperationQueue alloc] init];
    [self.graph startOperationsOnOperationQueue:self.backgroundQueue];
}

@end
