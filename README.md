# NDSOperationGraph

The goal of this library is to help manage ```NSOperationQueue``` dependencies. This allows you to create a dependency tree explicitly.

## Usage

Here is an example usage
```objc
// initialize the graph
NDSOperationGraph *graph = [[NDSOperationGraph alloc] init];

// Declare dependencies
[self.graph operationOfType:[NDSOperationBar class] dependsOn:[NDSOperationFoo class]];
[self.graph operationOfType:[NDSOperationZap class] dependsOn:[NDSOperationBar class]];

// setup success and failure blocks
[self.graph setSuccessBlock:^{
    NSLog(@"success finished");
}];
[self.graph setFailureBlock:^(NDSGraphOperationBase *operation, NSError *error, id errorObject){
    NSLog(@"errorObject %@", errorObject);
}];

// add operations
NDSOperationZap *zap = [[NDSOperationZap alloc] init];
NDSOperationFoo *foo1 = [[NDSOperationFoo alloc] init];
NDSOperationFoo *foo2 = [[NDSOperationFoo alloc] init];
NDSOperationFoo *foo3 = [[NDSOperationFoo alloc] init];
[self.graph addOperations:@[zap, foo1, foo2, foo3]];

// start it on whatever queue you want
[self.graph startOperationsOnOperationQueue:[NSOperationQueue mainQueue]];
```

Your operations must subclass ```NDSGraphOperationBase``` This is to stop operation if any of the operations fail.

In your subclass you are responsible for implementing ```operationWork```

You are responsible for calling ```finishSuccessWith:``` or ```finishFailureWith:object:``` depending on if it is a success or failure.

You can have any number of levels of dependencies. Dependencies are transitive. This mean if A depends on B and B depends on C. Then A depends on C. If you only have operations of A and C, any A operations won't execute until **all** C operations succeed.

See the the [Example](https://github.com/schlu/NDSOperationGraph/tree/master/Example) for detailed usage

## Installation

NDSOperationGraph is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "NDSOperationGraph"

## Author

Nicholas Schlueter, schlueter@gmail.com

## License

NDSOperationGraph is available under the MIT license. See the LICENSE file for more info.
