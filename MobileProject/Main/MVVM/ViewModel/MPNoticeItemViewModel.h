//
//  MPNoticeItemViewModel.h
//  MobileProject
//
//  Created by wujunyang on 2017/3/24.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MPNoticeModel;

@interface MPNoticeItemViewModel : NSObject

@property (nonatomic,copy,readonly) NSString *notice_title;

@property (nonatomic,copy,readonly) NSString *create_date;

@property (nonatomic,copy,readonly) NSString *notice_type;

- (instancetype)initWithModel:(MPNoticeModel *)model;

@end
