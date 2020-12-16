//
//  ViewController.m
//  ExNSThread
//
//  Created by muhlenXi on 2020/12/12.
//

#import "ViewController.h"
#import "MXThread.h"

@interface ViewController ()

@property (nonatomic, strong) NSThread *myThread;

@property (nonatomic, strong) MXThread *mxThread;

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL isQuiting;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // 方式一
//    NSThread *new = [[NSThread alloc] initWithTarget:self selector:@selector(doWork) object:nil];
//    new.name = @"mx";
//    [new start];
    
    // 方式二
//    [NSThread detachNewThreadWithBlock:^{
//        [self doWork];
//    }];
    
    // 方式三
//    [NSThread detachNewThreadSelector:@selector(doWork) toTarget:self withObject:nil];
    
//    [self performSelectorOnMainThread:@selector(doWork) withObject:nil waitUntilDone:NO];
    
    // 线程常驻
    self.myThread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"my thread block 调用了");
    }];
    self.myThread.name = @"mx thread";
    [self.myThread start];
    
    [self performSelector:@selector(doWork) onThread:self.myThread withObject:nil waitUntilDone:NO];
    
    self.mxThread = [[MXThread alloc] initWithBlock:^{
        NSLog(@"mx thread block 调用了");
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        while (!self.isQuiting) {
            [runloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        
//        [runloop run];
//        [runloop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:3600]];
//        [runloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }];
    [self.mxThread start];
    
    
//    [self.myThread cancel];
    
//    [self performSelectorInBackground:@selector(doWork) withObject:nil];
    
    NSLog(@"%s --> %@", __func__, [NSThread currentThread]);
    
    BOOL isExecuting = [self.myThread isExecuting];
    BOOL isCancelled = [self.myThread isCancelled];
    BOOL isFinished = [self.myThread isFinished];
    
    BOOL isMainThread = [self.myThread isMainThread];
    // 获取主线程
    NSThread *mainThread = [NSThread mainThread];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self performSelector:@selector(doWork) onThread:self.myThread withObject:nil waitUntilDone:NO];
    
//    [self.myThread main];
    BOOL isFinished = [self.mxThread isFinished];
    NSLog(@"mxThread finished --> %ld", isFinished);
    
    [self performSelector:@selector(doWork) onThread:self.mxThread withObject:nil waitUntilDone:NO];
    
    self.count += 1;
    if (self.count == 5) {
        self.isQuiting = YES;
        CFRunLoopStop(CFRunLoopGetCurrent());
    }
//    NSString *key = [NSString stringWithFormat:@"%ld", self.count];
//    [self.myThread.threadDictionary setValue:[NSDate date] forKey:key];
//
//    NSLog(@"%@", [self.myThread threadDictionary]);
    
//    [self.mxThread main];
}

- (void) doWork {
    NSLog(@"%s --> %@", __func__, [NSThread currentThread]);
    
//    NSLog(@"%s --> %@", __func__, [NSThread callStackReturnAddresses]);
//
//    NSLog(@"%s --> %@", __func__, [NSThread callStackSymbols]);
}


@end
