//
//  MPNoticeServiceImp.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/24.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPNoticeServiceImp.h"

@implementation MPNoticeServiceImp

-(RACSignal *)requestNoticeDataSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        MPNoticeService *service=[[MPNoticeService alloc]init];
        
        [service startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            MPNoticeListModel *listModel=[[MPNoticeListModel alloc]initWithString:request.responseString error:nil];
            
            if ([listModel.status isEqualToString:@"0"]) {
                NSLog(@"出错了");
                [subscriber sendError:nil];
            }
            else
            {
                [subscriber sendNext:listModel];
                [subscriber sendCompleted];
            }
            
        } failure:^(__kindof YTKBaseRequest *request) {
            NSLog(@"出错了");
            [subscriber sendError:nil];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"请求结束");
        }];
    }];
}

@end
