//
//  MPSettingViewModel.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/29.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPSettingViewModel.h"

@interface MPSettingViewModel()

@property (nonatomic, copy, readwrite) NSString *userName;

@property (nonatomic, copy) NSDictionary *country;

@end

@implementation MPSettingViewModel

- (void)initialize {
    [super initialize];

    
    self.country = self.country ?: @{
                                @"userName": @"wjy",
                                @"slug": @"",
                                };
    
    RAC(self, title) = [RACObserve(self, country) map:^(NSDictionary *country) {
        return country[@"slug"];
    }];
    
    RAC(self, userName) = [RACObserve(self, country) map:^(NSDictionary *country) {
        return country[@"userName"];
    }];
}

@end
