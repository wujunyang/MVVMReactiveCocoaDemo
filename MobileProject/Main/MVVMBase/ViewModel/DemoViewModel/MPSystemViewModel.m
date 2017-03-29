//
//  MPSystemViewModel.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/29.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPSystemViewModel.h"
#import "MPSettingViewModel.h"
#import "MPBaseViewModelServicesImpl.h"

@interface MPSystemViewModel()

@end

@implementation MPSystemViewModel

- (void)initialize {
    [super initialize];
    
    @weakify(self)
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^(NSIndexPath *indexPath) {
        @strongify(self)
        if (indexPath.section == 0 && indexPath.row == 0) {
            MPSettingViewModel *settingsViewModel = [[MPSettingViewModel alloc] initWithServices:self.services params:nil];
            [self.services pushViewModel:settingsViewModel animated:YES];
        }
        return [RACSignal empty];
    }];
}

@end
