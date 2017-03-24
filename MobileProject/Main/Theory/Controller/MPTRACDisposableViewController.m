//
//  MPTRACDisposableViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/24.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPTRACDisposableViewController.h"

@interface MPTRACDisposableViewController ()

@end

@implementation MPTRACDisposableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self createFirstDisposable];
    
    [self createDisposable];
    
    [self createMoreDisposable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//知识点：

//RACDisposable用于取消订阅信号，默认信号发送完之后就会主动的取消订阅。订阅信号使用的subscribeNext:方法返回的就是RACDisposable类型的对象

//当订阅者发送信号- (void)sendNext:(id)value之后，会执行：- (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock中的nextBlock。当nextBlock执行完毕也就意味着subscribeNext方法返回了RACDisposable对象。
//
//1.如果不强引用订阅者对象，默认情况下会自动取消订阅，我们可以拿到RACDisposable 用+ (instancetype)disposableWithBlock:(void (^)(void))block做清空资源的一些操作了。
//
//2.如果不希望自动取消订阅，我们应该强引用RACSubscriber * subscriber。在想要取消订阅的时候用- (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock返回的RACDisposable对象去调用- (void)dispose方法




-(void)createFirstDisposable
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];

        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"dispose!!!");
        }]; }];
    
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
        NSLog(@"next: %@", x);
    } completed:^{
        NSLog(@"complete");
    }];
    
//    输出：
//    2017-03-24 13:52:32.002  next: 1
//    2017-03-24 13:52:32.002  complete
//    2017-03-24 13:52:32.003  dispose!!!
}


-(void)createDisposable
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [RACScheduler.mainThreadScheduler afterDelay:2 schedule:^{
            [subscriber sendNext:@2];
            [subscriber sendCompleted];
        }];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"dispose!!!");
        }]; }];
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
        NSLog(@"next: %@", x);
    } completed:^{
        NSLog(@"complete");
    }];
    [RACScheduler.mainThreadScheduler afterDelay:1 schedule:^{
        [disposable dispose];
    }];
    
    //输出：
    //2017-03-24 09:27:50.297 next: 1
    //2017-03-24 09:27:51.367 dispose!!!
    
    //说明：因为[disposable dispose] 所以还没有执行都没有机会执行了;
}

-(void)createMoreDisposable
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        RACDisposable *disposable1 = [RACScheduler.mainThreadScheduler afterDelay:2 schedule:^{
            [subscriber sendNext:@2];
        }];
        RACDisposable *disposable2 = [RACScheduler.mainThreadScheduler afterDelay:2 schedule:^{
            [subscriber sendCompleted];
        }];
        return [RACDisposable disposableWithBlock:^{
            [disposable1 dispose];
            [disposable2 dispose];
            NSLog(@"dispose!!!");
        }]; }];
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
        NSLog(@"next: %@", x);
    } completed:^{
        NSLog(@"complete");
    }];
    [RACScheduler.mainThreadScheduler afterDelay:1 schedule:^{
        [disposable dispose];
    }];
    
//    输出：
//    2017-03-24 13:58:23.604 next: 1
//    2017-03-24 13:58:24.703 dispose!!!
}

@end
