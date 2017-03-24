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
