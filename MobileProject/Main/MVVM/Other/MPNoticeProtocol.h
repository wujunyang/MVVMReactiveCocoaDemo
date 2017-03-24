//
//  MPNoticeProtocol.h
//  MobileProject
//
//  Created by wujunyang on 2017/3/24.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MPNoticeProtocol <NSObject>

@optional

-(RACSignal *)requestNoticeDataSignal;

@end
