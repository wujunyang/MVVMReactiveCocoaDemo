//
//  MPNoticeService.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/24.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPNoticeService.h"

@implementation MPNoticeService

- (NSString *)requestUrl {
    return @"http://private-eda65-blossom.apiary-mock.com/notice/announcement_list";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

-(SERVERCENTER_TYPE)centerType
{
    return BUSINESSLOGIC_SERVERCENTER;
}

@end
