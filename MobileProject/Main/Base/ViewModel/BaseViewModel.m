//
//  BaseViewModel.m
//  MobileProject
//
//  Created by wujunyang on 16/1/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _errors = [RACSubject subject];
        
        _cancelCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal empty];
        }];
    }
    
    return self;
}

- (void)dealloc {
    [_errors sendCompleted];
}


@end
