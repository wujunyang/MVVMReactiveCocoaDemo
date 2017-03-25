//
//  MPNoticeItemViewModel.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/24.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPNoticeItemViewModel.h"
#import "MPNoticeModel.h"

@interface MPNoticeItemViewModel()
@property (nonatomic, strong) MPNoticeModel *model;
@end


@implementation MPNoticeItemViewModel

- (instancetype)initWithModel:(MPNoticeModel *)model
{
    if (self=[super init]) {
        _model=model;
    }
    return self;
}

-(NSString *)notice_title
{
    return self.model.notice_title;
}

-(NSString *)notice_type
{
    return self.model.notice_type;
}

-(NSString *)create_date
{
    return self.model.create_date;
}

@end
