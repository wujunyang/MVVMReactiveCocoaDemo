//
//  MPTRACSchedulerViewController.m
//  MobileProject  RACScheduler实现RAC关于并发的代码编写
//
//  Created by wujunyang on 2017/3/21.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPTRACSchedulerViewController.h"

@interface MPTRACSchedulerViewController ()

@end

@implementation MPTRACSchedulerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self SchedulerSigner];
    
    [self sendAsync];
    
    [self sendEverywhere];
    
    [self sendAndSubscribeEverywhere];
    
    [self useSubscribeOn];
    
    [self useDeliverOn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//关于几种Scheduler的创建
-(void)SchedulerInfo
{
    //主线程的Scheduler
    RACScheduler *mainScheduler = [RACScheduler mainThreadScheduler];
    
    //子线程的两个Scheduler  注意[RACScheduler scheduler]是返回一个新的
    RACScheduler *scheduler1 = [RACScheduler scheduler];
    RACScheduler *scheduler2 = [RACScheduler scheduler];
    
    //返回当前的Scheduler，自定义的线程会返回nil
    RACScheduler *scheduler3 = [RACScheduler currentScheduler];
    
    // 创建某优先级的Scheduler，不建议除非你知道你在干什么
    RACScheduler *scheduler4 = [RACScheduler schedulerWithPriority:RACSchedulerPriorityHigh];
    RACScheduler *scheduler5 = [RACScheduler schedulerWithPriority:RACSchedulerPriorityHigh
                                                              name:@"someName"];
    
    //马上创建Scheduler，不建议除非你知道你在干什么
    RACScheduler *scheduler6 = [RACScheduler immediateScheduler];
}


//异步订阅
-(void)SchedulerSigner
{
    RACSignal *signer=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"%@ 111",[NSThread currentThread]);
        [subscriber sendNext:@"2"];
        [subscriber sendNext:@"5"];
        
        return nil;
    }];
    
    [[RACScheduler scheduler]schedule:^{
        NSLog(@"创建一个子线程");
        
        [signer subscribeNext:^(id x) {
            NSLog(@"%@,值：%@",[NSThread currentThread],x);
        }];
    }];
    
//    输出：
//    创建一个子线程
//    <NSThread: 0x60000027f480>{number = 3, name = (null)} 111
//    <NSThread: 0x6080002781c0>{number = 3, name = (null)},值：2
//    <NSThread: 0x6080002781c0>{number = 3, name = (null)},值：5
//    异步订阅都是在子线程中进行处理 则signer里面的代码也在子线程中
}


//异步发送
-(void)sendAsync
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"%@ 111",[NSThread currentThread]);
        RACDisposable *disposable = [[RACScheduler scheduler] schedule:^{
            [subscriber sendNext:@1];
            [subscriber sendCompleted];
        }];
        return disposable;
    }];
    NSLog(@"%@ 222",[NSThread currentThread]);
    [signal subscribeNext:^(id x) {
        NSLog(@"%@ 333",[NSThread currentThread]);
    }];
    NSLog(@"%@ 444",[NSThread currentThread]);
    
//    输出
//    <NSThread: 0x600000064140>{number = 1, name = main} 222
//    <NSThread: 0x600000064140>{number = 1, name = main} 111
//    <NSThread: 0x600000064140>{number = 1, name = main} 444
//    <NSThread: 0x6080002614c0>{number = 3, name = (null)} 333
//    异步发送时 订阅到的是在子线程中进行操作 而发送里是在主线程中
}


//同步+异步发送
-(void)sendEverywhere
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"%@ 111",[NSThread currentThread]);
        [subscriber sendNext:@0.1];
        RACDisposable *disposable = [[RACScheduler scheduler] schedule:^{
            [subscriber sendNext:@1.1];
            [subscriber sendCompleted];
        }];
        return disposable;
    }];
    NSLog(@"%@ 222",[NSThread currentThread]);
    [signal subscribeNext:^(id x) {
        NSLog(@"%@ %@",[NSThread currentThread],x);
    }];
    NSLog(@"%@ 444",[NSThread currentThread]);
    
//    输出
//    <NSThread: 0x60800007af00>{number = 1, name = main} 222
//    <NSThread: 0x60800007af00>{number = 1, name = main} 111
//    <NSThread: 0x60800007af00>{number = 1, name = main} 0.1
//    <NSThread: 0x60800007af00>{number = 1, name = main} 444
//    <NSThread: 0x600000278100>{number = 6, name = (null)} 1.1
}


//异步订阅+异步发送+同步发送
-(void)sendAndSubscribeEverywhere
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"%@ 111",[NSThread currentThread]);
        [subscriber sendNext:@0.1];
        RACDisposable *disposable = [[RACScheduler scheduler] schedule:^{
            NSLog(@"%@ 555",[NSThread currentThread]);
            [subscriber sendNext:@1.1];
            [subscriber sendCompleted];
        }];
        return disposable;
    }];
    [[RACScheduler scheduler] schedule:^{
        NSLog(@"%@ 222",[NSThread currentThread]);
        [signal subscribeNext:^(id x) {
            NSLog(@"%@ %@",[NSThread currentThread], x);
        }]; }];
    NSLog(@"%@ 444",[NSThread currentThread]);
    
    
//    输出
//    <NSThread: 0x608000275780>{number = 6, name = (null)} 222
//    <NSThread: 0x608000070240>{number = 1, name = main} 444
//    <NSThread: 0x608000275780>{number = 6, name = (null)} 111
//    <NSThread: 0x608000275780>{number = 6, name = (null)} 0.1
//    <NSThread: 0x608000275780>{number = 6, name = (null)} 555
//    <NSThread: 0x608000275780>{number = 6, name = (null)} 1.1
//    此时除了444在主线程中，其它都是在子线程中进行处理  1.1 跟0.1 可能不在同一个子线程上
}


//subscribeOn运用  订阅时机不确定时 —> subscribeOn:
-(void)useSubscribeOn
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"%@ 111",[NSThread currentThread]);
        
        //可以放更新UI操作
        
        [subscriber sendNext:@0.1];
        RACDisposable *disposable = [[RACScheduler scheduler] schedule:^{
            NSLog(@"%@ 5555",[NSThread currentThread]);
            [subscriber sendNext:@1.1];
            [subscriber sendCompleted];
        }];
        return disposable;
    }];
    [[RACScheduler scheduler] schedule:^{
        NSLog(@"%@ 222",[NSThread currentThread]);
        [[signal subscribeOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
            NSLog(@"%@ %@",[NSThread currentThread], x);
        }]; }];
    NSLog(@"%@ 4444",[NSThread currentThread]);
    
//    输出
//    <NSThread: 0x600000260a40>{number = 1, name = main} 4444
//    <NSThread: 0x608000460580>{number = 3, name = (null)} 222
//    <NSThread: 0x600000260a40>{number = 1, name = main} 111
//    <NSThread: 0x600000260a40>{number = 1, name = main} 0.1
//    <NSThread: 0x600000475b80>{number = 6, name = (null)} 5555
//    <NSThread: 0x600000475b80>{number = 6, name = (null)} 1.1
//    使用subscribeOn 可以让signal内的代码在主线程中运行，sendNext在哪个线程 则对应的订阅输出就在对应线程上，所以0.1输出是在主线程中； 所以当在signal里面可能要放一些更新UI的操作，而这些是要在主线程才能处理，而订阅者却无法确认，所以要使用subscribeOn让它在主线程中；
//   能够保证didSubscribe block在指定的scheduler
//   不能保证sendNext、 error、 complete在哪个scheduler
}

//发送时机不确定时 deliverOn:
-(void)useDeliverOn
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"%@ 111",[NSThread currentThread]);
        [subscriber sendNext:@0.1];
        RACDisposable *disposable = [[RACScheduler scheduler] schedule:^{
            NSLog(@"%@ 555",[NSThread currentThread]);
            [subscriber sendNext:@1.1];
            [subscriber sendCompleted];
        }];
        return disposable;
    }];
    [[RACScheduler scheduler] schedule:^{
        NSLog(@"%@ 222",[NSThread currentThread]);
        [[signal deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
            NSLog(@"%@ %@",[NSThread currentThread], x);
            
            //可以放UI更新操作
            
        }]; }];
    NSLog(@"%@ 444",[NSThread currentThread]);
    
//    输出
//    <NSThread: 0x600000260040>{number = 1, name = main} 444
//    <NSThread: 0x600000666780>{number = 6, name = (null)} 222
//    <NSThread: 0x600000666780>{number = 6, name = (null)} 111
//    <NSThread: 0x600000666780>{number = 6, name = (null)} 555
//    <NSThread: 0x600000260040>{number = 1, name = main} 0.1
//    <NSThread: 0x600000260040>{number = 1, name = main} 1.1
//    当我们让订阅的处理代码在指定的线程中执行，而不必去关心发送信号的当前线程，就可以deliverOn
}
@end
