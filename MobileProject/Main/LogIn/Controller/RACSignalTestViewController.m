//
//  RACSignalTestViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/2/1.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "RACSignalTestViewController.h"

@interface RACSignalTestViewController ()
@property(nonatomic,strong)RACSignal *mySignal,*secondSingl;
@end

@implementation RACSignalTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    
    //map运用 返回的值作为next的参数
    [[self.mySignal map:^id(NSNumber *value) {
        return [value integerValue]>5?@"踏浪帅":@"有点小";
    }] subscribeNext:^(NSString *str) {
        NSLog(@"map处理完成的值为：%@",str);
    }];
    
    //filter:过滤信号，使用它可以获取满足条件的信号.
    [[self.mySignal filter:^BOOL(NSNumber *item) {
        return [item integerValue]>5;
    }] subscribeNext:^(NSNumber *x) {
        NSLog(@"filter当前的值%ld",[x integerValue]);
    }];
    
    
    //ignore:忽略完某些值的信号.当答合被ignore的值时就不会执行next
    [[self.mySignal ignore:@10] subscribeNext:^(id x) {
        NSLog(@"ignore当前的值:%@",x);
    }];
    
    //distinctUntilChanged:当上一次的值和当前的值有明显的变化就会发出信号，否则会被忽略掉。
    [[self.mySignal distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"distinctUntilChanged当前的值:%@",x);
    }];
    
    //take:从开始一共取N次的信号
    //takeLast:取最后N次的信号,前提条件，订阅者必须调用完成，因为只有完成，就知道总共有多少信号.
    //takeUntil:(RACSignal *):获取信号直到某个信号执行完成
    //skip:(NSUInteger):跳过几个信号,不接受。
    
    
    //concat:按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号
    RACSignal *concatSignal=[self.mySignal concat:self.secondSingl];
    [concatSignal subscribeNext:^(id x) {
        NSLog(@"concat拼接的值：%@",x);
    }];

    
    //then:用于连接两个信号，当第一个信号完成，才会连接then返回的信号
    [[self.mySignal then:^RACSignal *{
        @strongify(self);
        return self.secondSingl;
    }] subscribeNext:^(id x) {
        //// 只能接收到第二个信号的值，也就是then返回信号的值
        NSLog(@"then当前的值为：%@",x);
    }];
    
    
    //merge:把多个信号合并为一个信号，任何一个信号有新值的时候就会调用
    RACSignal *mergeSignal=[self.mySignal merge:self.secondSingl];
    [mergeSignal subscribeNext:^(id x) {
        NSLog(@"merge当前的值为:%@",x);
    }];
    
    
    //combineLatest:将多个信号合并起来，并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，两个信号的内容合并成一个元组RACTuple,才会触发合并的信号。
    RACSignal *combineLatestSignal=[self.mySignal combineLatestWith:self.secondSingl];
    [combineLatestSignal subscribeNext:^(id x) {
        NSLog(@"combineLastest当前的值为：%@",x);
    }];
    
    
    //zipWith:把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元组RACTuple，才会触发压缩流的next事件。
    RACSignal *zipWithSignal=[self.mySignal zipWith:self.secondSingl];
    [zipWithSignal subscribeNext:^(RACTuple *tuple) {
        NSLog(@"zipWith当前的值为：%@",tuple);
        
        NSLog(@"zipWith中的RACTuple共有几个值：%ld",tuple.count);
        
        NSLog(@"zipWith中的RACTuple第一个值为：%@",tuple.first);
        
        NSLog(@"zipWith中的RACTuple最后一个值为：%@",tuple.last);
    }];
    
    
    //reduce聚合:用于信号发出的内容是元组，把信号发出元组的值聚合成一个值 特别是combineLatestWith,zipWith这种返回元组的RACTuple,reduceblcok中的参数，有多少信号组合，reduceblcok就有多少参数，每个参数就是之前信号发出的内容
    RACSignal *reduceSignal=[RACSignal combineLatest:@[self.mySignal,self.secondSingl] reduce:^id(NSNumber *num1 ,NSNumber *num2){
        NSLog(@"combineLastest结合reduct的第一个值为：%ld 第二个值为：%ld",[num1 integerValue],[num2 integerValue]);
        return ([num1 integerValue]>10&&[num2 integerValue]>15)?@"两个都符合要求":@"都没有答合要求";
    }];
    [reduceSignal subscribeNext:^(id x) {
        NSLog(@"reduce当前的值为：%@",x);
    }];
    
    
    //doNext: 执行Next之前，会先执行这个Block,可以做一些初使化的功能,doCompleted: 执行sendCompleted之前，会先执行这个Block
    [[[self.mySignal doNext:^(id x) {
        NSLog(@"doNext当前的值：%@",x);
    }] doCompleted:^{
        NSLog(@"doComplete 执行到了");
    }] subscribeNext:^(id x) {
        NSLog(@"测试doNext,doComplete的值：%@",x);
    }];
    
    //switchToLatest:用于signalOfSignals（信号的信号），有时候信号也会发出信号，会在signalOfSignals中，获取signalOfSignals发送的最新信号。
    RACSubject *signalOfSignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    
    // 获取信号中信号最近发出信号，订阅最近发出的信号。
    // 注意switchToLatest：只能用于信号中的信号
    [signalOfSignals.switchToLatest subscribeNext:^(id x) {
        
        NSLog(@"switchToLatest%@",x);
    }];
    [signalOfSignals sendNext:signal];
    [signal sendNext:@1];
    
    //deliverOn: 内容传递切换到制定线程中，副作用在原来线程中,把在创建信号时block中的代码称之为副作用。
    //subscribeOn: 内容传递和副作用都会切换到制定线程中。'
    
    
    //timeout：超时，可以让一个信号在一定的时间后，自动报错。
    [[self.mySignal timeout:1 onScheduler:[RACScheduler currentScheduler]]
     subscribeNext:^(id x) {
         NSLog(@"timeout当前的值：%@",x);
     } error:^(NSError *error) {
         NSLog(@"timeout 超时了");
     }];
    
    
    //delay 延迟发送next。
    [[self.mySignal delay:2] subscribeNext:^(id x) {
        NSLog(@"delay执行%@",x);
    }];
    
    
    //retry重试 ：只要失败，就会重新执行创建信号中的block,直到成功.
    __block int i = 0;
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        if (i == 10) {
            [subscriber sendNext:@100];
        }else{
            NSLog(@"接收到错误");
            [subscriber sendError:nil];
        }
        i++;
        
        return nil;
        
    }] retry] subscribeNext:^(id x) {
        
        NSLog(@"retry当前的值：%@",x);
        
    } error:^(NSError *error) {
        
    }];
    
    
    //普通执行多次订阅
    RACSignal *oneSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        return nil;
    }] replay];
    [oneSignal subscribeNext:^(id x) {
        NSLog(@"第一个没有replay执行的内容：%@",x);
    }];
    [oneSignal subscribeNext:^(id x) {
        NSLog(@"第二个没有replay执行的内容：%@",x);
    }];
    
    
    //replay重放：当一个信号被多次订阅,反复播放内容
    RACSignal *replaySignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        return nil;
    }] replay];
    
    [replaySignal subscribeNext:^(id x) {
        NSLog(@"replay第一个订阅者%@",x);
    }];
    
    [replaySignal subscribeNext:^(id x) {
        NSLog(@"replay第二个订阅者%@",x);
    }];
    
    
    //interval 定时：每隔一段时间发出信号
    [[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]] subscribeNext:^(id x) {
        NSLog(@"interval一直在执行：%@",x);
    }];
    
    //throttle节流:当某个信号发送比较频繁时，可以使用节流，在某一段时间不发送信号内容，过了一段时间获取信号的最新内容发出。
    
    //双向绑定
    
}

-(RACSignal *)mySignal
{
    if (!_mySignal) {
        _mySignal=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@10];
            [subscriber sendCompleted];
            return nil;
        }];
    }
    
    return _mySignal;
}

-(RACSignal *)secondSingl
{
    if (!_secondSingl) {
        _secondSingl=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@20];
            [subscriber sendCompleted];
            return nil;
        }];
    }
    return _secondSingl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
