## VSPromise

A simple lightweight Objective-C promises.

## Features

  - Automatic memory management. You can store promise in weak variable or not store at all, it will be released automatically after resolwing
  - Chains with any length 
  - Transformation of result
  - Thread-safe

## Installation

VSPromise supports two methods for installing it in a project.

#### Installation with CocoaPods

To integrate VSPromise into your Xcode project using CocoaPods, specify it in your `Podfile`:

```shell
target 'TargetName' do
    pod 'VSPromise'
end
```

Then, run the following command:

```shell
$ pod install
```

#### Installation with 'Drag-and-Drop'

Just copy files from 'Source' folder into your project and add them to your target.

## Usage:
#### Basic usage
```objective-c
VSPromise *promise = ...;
promise.then(^id(id result) {
    // `result` is a result of previous promise
    ...

    return somePromise;
})
.then(^id(id result) {
    // You can instert any number of `then` blocks and return promise or nil

    return somePromise;
})
.fail(^id(NSError *error) {
    // This block will be called, if you get and error in any previous `then` block
    
    return nil;
})
.finaly(^{
    // This block will be called after all then or fail blocks.
});
```

#### How to use promises in your async methods
```objective-c
- (VSPromise *)someAsyncMethod:(id)params
{
    VSPromise *promise = [VSPromise promise];
    [self someAsyncMethodWithCompletion:^(id result, NSError *error) { 
        if (!error) {
            [promise resolve:result];
        }
        else {
            [promise reject:error];
        }
    });

    return promise;
}
```

#### Transform results
```objective-c
VSPromise *promise = ...;
[promise map:^NSURL *(NSDictionary *json) {
    NSString *path = json[@"url"];
    
    return path.length ? [NSURL URLWithString:path] : nil;
}];
```

## License
VSPromise is available under the MIT license. See the LICENSE file for more info.
