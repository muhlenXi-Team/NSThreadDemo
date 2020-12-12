//
//  ViewController.m
//  ExNSThread
//
//  Created by muhlenXi on 2020/12/12.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong) NSThread *myThread;

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
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runloop run];
    }];
    self.myThread.name = @"mx thread";
    [self.myThread start];
    
    [self performSelector:@selector(doWork) onThread:self.myThread withObject:nil waitUntilDone:NO];
    
//    [self performSelectorInBackground:@selector(doWork) withObject:nil];
    
    NSLog(@"%s --> %@", __func__, [NSThread currentThread]);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self performSelector:@selector(doWork) onThread:self.myThread withObject:nil waitUntilDone:NO];
}

- (void) doWork {
    NSLog(@"%s --> %@", __func__, [NSThread currentThread]);
}


@end
