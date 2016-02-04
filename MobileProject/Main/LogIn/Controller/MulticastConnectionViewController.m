//
//  MulticastConnectionViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/2/3.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "MulticastConnectionViewController.h"

@interface MulticastConnectionViewController ()

@end

@implementation MulticastConnectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __block int aNumber = 0;
    
    // Signal that will have the side effect of incrementing `aNumber` block
    // variable for each subscription before sending it.
    RACSignal *aSignal = [RACSignal createSignal:^ RACDisposable * (id<RACSubscriber> subscriber) {
        aNumber++;
        [subscriber sendNext:@(aNumber)];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACMulticastConnection *connection = [aSignal multicast:[RACReplaySubject subject]];
    [connection connect];
    
    // This will print "subscriber one: 1"
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"subscriber one: %@", x);
    }];
    
    // This will print "subscriber two: 1"
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"subscriber two: %@", x);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
