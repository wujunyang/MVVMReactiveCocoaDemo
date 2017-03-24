//
//  MPTHotAndColdSignalViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/21.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPTHotAndColdSignalViewController.h"

@interface MPTHotAndColdSignalViewController ()

@end

@implementation MPTHotAndColdSignalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self aboutColdSignal];
    
    [self aboutHotSignal];
    
    [self aboutSubjectSignal];
    
    [self changeColdToHitSignal];
    
    [self aboutOtherColdToHitSignal];
    
    [self aboutReplayLazilySignal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//知识点说明：

//Hot Observable是主动的，尽管你并没有订阅事件，但是它会时刻推送，就像鼠标移动；而Cold Observable是被动的，只有当你订阅的时候，它才会发布消息。

//Hot Observable可以有多个订阅者，是一对多，集合可以与订阅者共享信息；而Cold Observable只能一对一，当有不同的订阅者，消息是重新完整发送。


//热信号是主动的，即使你没有订阅事件，它仍然会时刻推送 而冷信号是被动的，只有当你订阅的时候，它才会发送消息
//热信号可以有多个订阅者，是一对多，信号可以与订阅者共享信息 而冷信号只能一对一，当有不同的订阅者，消息会从新完整发送

//冷信号与热信号的本质区别在于是否保持状态，冷信号的多次订阅是不保持状态的，而热信号的多次订阅可以保持状态




//冷信号并不关于订阅者，只有有要订阅，它都会重头再执行一遍关于信号的发送  一对一
-(void)aboutColdSignal
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendNext:@3];
        [subscriber sendCompleted];
        return nil;
    }];
    NSLog(@"Signal was created.");
    [[RACScheduler mainThreadScheduler] afterDelay:0.1 schedule:^{
        [signal subscribeNext:^(id x) {
            NSLog(@"Subscriber 1 recveive: %@", x);
        }];
    }];
    
    [[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
        [signal subscribeNext:^(id x) {
            NSLog(@"Subscriber 2 recveive: %@", x);
        }];
    }];
    
    
    //输出：
//    Signal was created.
//    Subscriber 1 recveive: 1
//    Subscriber 1 recveive: 2
//    Subscriber 1 recveive: 3
//    
//    Subscriber 2 recveive: 1
//    Subscriber 2 recveive: 2
//    Subscriber 2 recveive: 3
//    说明了变量名为signal的这个信号，在两个不同时间段的订阅过程中，分别完整地发送了所有的消息
}


//热信号关心订阅者  它会主动发送  publish可以把冷信号转成热信号 一对多
-(void)aboutHotSignal
{
    RACMulticastConnection *connection = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
            [subscriber sendNext:@1];
        }];
        
        [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
            [subscriber sendNext:@2];
        }];
        
        [[RACScheduler mainThreadScheduler] afterDelay:3 schedule:^{
            [subscriber sendNext:@3];
        }];
        
        [[RACScheduler mainThreadScheduler] afterDelay:4 schedule:^{
            [subscriber sendCompleted];
        }];
        return nil;
    }] publish];
    [connection connect];
    RACSignal *signal = connection.signal;
    
    NSLog(@"Signal was created.");
    //分别在1.1秒和2.1秒订阅获得的信号。
    [[RACScheduler mainThreadScheduler] afterDelay:1.1 schedule:^{
        [signal subscribeNext:^(id x) {
            NSLog(@"Subscriber 1 recveive: %@", x);
        }];
    }];
    
    [[RACScheduler mainThreadScheduler] afterDelay:2.1 schedule:^{
        [signal subscribeNext:^(id x) {
            NSLog(@"Subscriber 2 recveive: %@", x);
        }];
    }];
    
//    输出
//    Signal was created.
//    Subscriber 1 recveive: 2
//    Subscriber 1 recveive: 3
//    Subscriber 2 recveive: 3
//    所以只有在符合时才接收到内容，而信号是主动发，订阅者要是错过就错过了
    
//    实例
//    创建了一个信号，在1秒、2秒、3秒分别发送1、2、3这三个值，4秒发送结束信号。
//    对这个信号调用publish方法得到一个RACMulticastConnection。
//    让connection进行连接操作。
//    获得connection的信号。
//    分别在1.1秒和2.1秒订阅获得的信号。
}


//RACSubject 是一个热信号
//Subject是“可变”的。
//Subject是非RAC到RAC的一个桥梁。
//Subject可以附加行为，例如RACReplaySubject具备为未来订阅者缓冲事件的能力
-(void)aboutSubjectSignal
{
    RACSubject *subject = [RACSubject subject];
    RACSubject *replaySubject = [RACReplaySubject subject];
    
    [[RACScheduler mainThreadScheduler] afterDelay:0.1 schedule:^{
        // Subscriber 1
        [subject subscribeNext:^(id x) {
            NSLog(@"Subscriber 1 get a next value: %@ from subject", x);
        }];
        [replaySubject subscribeNext:^(id x) {
            NSLog(@"Subscriber 1 get a next value: %@ from replay subject", x);
        }];
        
        // Subscriber 2
        [subject subscribeNext:^(id x) {
            NSLog(@"Subscriber 2 get a next value: %@ from subject", x);
        }];
        [replaySubject subscribeNext:^(id x) {
            NSLog(@"Subscriber 2 get a next value: %@ from replay subject", x);
        }];
    }];
    
    [[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
        [subject sendNext:@"send package 1"];
        [replaySubject sendNext:@"send package 1"];
    }];
    
    
    
    
    [[RACScheduler mainThreadScheduler] afterDelay:1.1 schedule:^{
        // Subscriber 3
        [subject subscribeNext:^(id x) {
            NSLog(@"Subscriber 3 get a next value: %@ from subject", x);
        }];
        [replaySubject subscribeNext:^(id x) {
            NSLog(@"Subscriber 3 get a next value: %@ from replay subject", x);
        }];
        
        // Subscriber 4
        [subject subscribeNext:^(id x) {
            NSLog(@"Subscriber 4 get a next value: %@ from subject", x);
        }];
        [replaySubject subscribeNext:^(id x) {
            NSLog(@"Subscriber 4 get a next value: %@ from replay subject", x);
        }];
    }];
    
    [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
        [subject sendNext:@"send package 2"];
        [replaySubject sendNext:@"send package 2"];
    }];
    
    
//    输出
//    Subscriber 1 get a next value: send package 1 from subject
//    Subscriber 2 get a next value: send package 1 from subject
//    Subscriber 1 get a next value: send package 1 from replay subject
//    Subscriber 2 get a next value: send package 1 from replay subject
//    Subscriber 3 get a next value: send package 1 from replay subject
//    Subscriber 4 get a next value: send package 1 from replay subject
//    Subscriber 1 get a next value: send package 2 from subject
//    Subscriber 2 get a next value: send package 2 from subject
//    Subscriber 3 get a next value: send package 2 from subject
//    Subscriber 4 get a next value: send package 2 from subject
//    Subscriber 1 get a next value: send package 2 from replay subject
//    Subscriber 2 get a next value: send package 2 from replay subject
//    Subscriber 3 get a next value: send package 2 from replay subject
//    Subscriber 4 get a next value: send package 2 from replay subject
    
//    RACSubject及其子类是热信号。
//    RACSignal排除RACSubject类以外的是冷信号
}


//如何将一个冷信号转化成热信号 将冷信号订阅，订阅到的每一个时间通过RACSbuject发送出去，其他订阅者只订阅这个RACSubject
-(void)changeColdToHitSignal
{
    RACSignal *coldSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"Cold signal be subscribed.");
        [[RACScheduler mainThreadScheduler] afterDelay:1.5 schedule:^{
            [subscriber sendNext:@"A"];
        }];
        
        [[RACScheduler mainThreadScheduler] afterDelay:3 schedule:^{
            [subscriber sendNext:@"B"];
        }];
        
        [[RACScheduler mainThreadScheduler] afterDelay:5 schedule:^{
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
    
    RACSubject *subject = [RACSubject subject];
    NSLog(@"Subject created.");
    
    [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
        [coldSignal subscribe:subject];
    }];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"Subscriber 1 recieve value:%@.", x);
    }];
    
    [[RACScheduler mainThreadScheduler] afterDelay:4 schedule:^{
        [subject subscribeNext:^(id x) {
            NSLog(@"Subscriber 2 recieve value:%@.", x);
        }];
    }];
    
//    输出
//    Subject created.
//    Cold signal be subscribed.
//    Subscriber 1 recieve value:A.
//    Subscriber 1 recieve value:B.
//    Subscriber 2 recieve value:B.
    
//    实例
//    创建一个冷信号：coldSignal。该信号声明了“订阅后1.5秒发送‘A’，3秒发送'B'，5秒发送完成事件”。
//    创建一个RACSubject：subject。
//    在2秒后使用这个subject订阅coldSignal。
//    立即订阅这个subject。
//    4秒后订阅这个subject
    
//    http://tech.meituan.com/talk-about-reactivecocoas-cold-signal-and-hot-signal-part-3.html
}

//RAC库中对于冷信号转化成热信号有如下标准的封装
//- (RACMulticastConnection *)publish;
//- (RACMulticastConnection *)multicast:(RACSubject *)subject;
//- (RACSignal *)replay;
//- (RACSignal *)replayLast;
//- (RACSignal *)replayLazily;

//- (RACMulticastConnection *)publish就是帮忙创建了RACSubject。
//- (RACSignal *)replay就是用RACReplaySubject来作为subject，并立即执行connect操作，返回connection.signal。其作用是上面提到的replay功能，即后来的订阅者可以收到历史值。
//- (RACSignal *)replayLast就是用Capacity为1的RACReplaySubject来替换- (RACSignal *)replay的`subject。其作用是使后来订阅者只收到最后的历史值。
//- (RACSignal *)replayLazily和- (RACSignal *)replay的区别就是replayLazily会在第一次订阅的时候才订阅sourceSignal。

//replay、replayLast、replayLazily的区别 ReactiveCocoa提供了这三个简便的方法允许多个订阅者订阅一个信号，却不会重复执行订阅代码，并且能给新加的订阅者提供订阅前的值。replay和replayLast使信号变成热信号，且会提供所有值(-replay) 或者最新的值(-replayLast) 给订阅者。 replayLazily 会提供所有的值给订阅者 避免了冷信号的副作用


-(void)aboutOtherColdToHitSignal
{
    RACSignal *coldSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"Cold signal be subscribed.");
        [[RACScheduler mainThreadScheduler] afterDelay:1.5 schedule:^{
            [subscriber sendNext:@"A"];
        }];
        
        [[RACScheduler mainThreadScheduler] afterDelay:3 schedule:^{
            [subscriber sendNext:@"B"];
        }];
        
        [[RACScheduler mainThreadScheduler] afterDelay:5 schedule:^{
            [subscriber sendCompleted];
        }];
        
        
        return nil;
    }];
    
    RACSubject *subject = [RACSubject subject];
    NSLog(@"Subject created.");
    
    RACMulticastConnection *multicastConnection = [coldSignal multicast:subject];
    RACSignal *hotSignal = multicastConnection.signal;
    
    [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
        [multicastConnection connect];
    }];
    
    [hotSignal subscribeNext:^(id x) {
        NSLog(@"Subscribe 1 recieve value:%@.", x);
    }];
    
    [[RACScheduler mainThreadScheduler] afterDelay:4 schedule:^{
        [hotSignal subscribeNext:^(id x) {
            NSLog(@"Subscribe 2 recieve value:%@.", x);
        }];
    }];
    
//    输出
//    2017-03-21 16:01:40.521 Subject created.
//    2017-03-21 16:01:42.710 Cold signal be subscribed.
//    2017-03-21 16:01:44.359 Subscribe 1 recieve value:A.
//    2017-03-21 16:01:45.954 Subscribe 1 recieve value:B.
//    2017-03-21 16:01:45.955 Subscribe 2 recieve value:B.
}


-(void)aboutReplayLazilySignal
{
    RACSignal *coldSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"Cold signal be subscribed.");
        [[RACScheduler mainThreadScheduler] afterDelay:1.5 schedule:^{
            [subscriber sendNext:@"A"];
        }];
        
        [[RACScheduler mainThreadScheduler] afterDelay:3 schedule:^{
            [subscriber sendNext:@"B"];
        }];
        
        [[RACScheduler mainThreadScheduler] afterDelay:5 schedule:^{
            [subscriber sendCompleted];
        }];
        
        
        return nil;
    }];
    

    RACSignal *signal = [coldSignal replayLazily];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"Subscribe 1 recieve value:%@.", x);
    }];
    
    [[RACScheduler mainThreadScheduler] afterDelay:4 schedule:^{
        [signal subscribeNext:^(id x) {
            NSLog(@"Subscribe 2 recieve value:%@.", x);
        }];
    }];
    
//    输出
//    2017-03-21 16:20:58.237  Cold signal be subscribed.
//    2017-03-21 16:20:59.857  Subscribe 1 recieve value:A.
//    2017-03-21 16:21:01.535  Subscribe 1 recieve value:B.
//    2017-03-21 16:21:02.636  Subscribe 2 recieve value:A.
//    2017-03-21 16:21:02.636  Subscribe 2 recieve value:B.

//    说明：Cold signal be subscribed只被执行一次，虽然它被两次订阅；
    
    
//    如果不用replayLazily
//    
//    [coldSignal subscribeNext:^(id x) {
//        NSLog(@"Subscribe 1 recieve value:%@.", x);
//    }];
//    
//    [[RACScheduler mainThreadScheduler] afterDelay:4 schedule:^{
//        [coldSignal subscribeNext:^(id x) {
//            NSLog(@"Subscribe 2 recieve value:%@.", x);
//        }];
//    }];
//    
//    2017-03-21 16:31:37.426 Cold signal be subscribed.
//    2017-03-21 16:31:38.926 Subscribe 1 recieve value:A.
//    2017-03-21 16:31:40.426 Subscribe 1 recieve value:B.
//    2017-03-21 16:31:41.821 Cold signal be subscribed.
//    2017-03-21 16:31:43.465 Subscribe 2 recieve value:A.
//    2017-03-21 16:31:45.119 Subscribe 2 recieve value:B.
//    
//    会发现Cold signal be subscribed.被执行的两次 就是有副作用，如果是网络请求放在这就会执行两次相同的操作，要是如点赞的操作，那么它就会执行两次，就会产生业务错误了
}

@end
