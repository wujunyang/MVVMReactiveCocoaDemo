//
//  MPTRACHightSignalViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/7.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPTRACHightSignalViewController.h"

@interface MPTRACHightSignalViewController ()

@end

@implementation MPTRACHightSignalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self createHeightSignal];
    [self createflatten];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//创建高阶RACSignal
-(void)createHeightSignal
{
    //1:创建高阶的方式
    RACSignal *signal=[RACSignal return:@"1"];
    
    RACSignal *heightSignal=[RACSignal return:signal];
    
    //2:创建高阶的方式
    RACSignal *anotherHightSignal=[signal map:^id(id value) {
        return [RACSignal return:value];
    }];
    
    //解读方式1
    [heightSignal subscribeNext:^(RACSignal *nextSignal) {
        [nextSignal subscribeNext:^(id x) {
            NSLog(@"当前的值：%@",x);
        }];
    }];
    
    //解读方式2
    [[anotherHightSignal switchToLatest] subscribeNext:^(id x) {
        NSLog(@"switchToLatest 当前的值：%@",x);
    }];
}

-(void)createflatten
{
    RACSignal *signal = @[@1, @2, @3].rac_sequence.signal;
    RACSignal *mapSignal=[[signal map:^id(NSNumber *value) {
        return [[[RACSignal return:value] repeat] take:value.integerValue];
    }] flatten];
    
    [mapSignal subscribeNext:^(NSNumber *value) {
        NSLog(@"flatten 当前的值：%d",[value intValue]);
    }];
    
//    输出：
//    flatten 当前的值：1
//    flatten 当前的值：2
//    flatten 当前的值：2
//    flatten 当前的值：3
//    flatten 当前的值：3
//    flatten 当前的值：3
}

@end
