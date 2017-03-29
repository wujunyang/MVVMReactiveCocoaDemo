//
//  MPHomePageViewModel.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/29.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPHomePageViewModel.h"

@interface MPHomePageViewModel()

@property (nonatomic, strong, readwrite) MPProjectViewModel *projectViewModel;

@property (nonatomic, strong, readwrite) MPSystemViewModel *systemViewModel;

@property (nonatomic, strong, readwrite) MPTTheoryViewModel *theoryViewModel;
@end

@implementation MPHomePageViewModel

- (void)initialize {
    [super initialize];
    
    self.projectViewModel    = [[MPProjectViewModel alloc] initWithServices:self.services params:nil];
    self.systemViewModel   = [[MPSystemViewModel alloc] initWithServices:self.services params:nil];
    self.theoryViewModel = [[MPTTheoryViewModel alloc] initWithServices:self.services params:nil];
}

@end
