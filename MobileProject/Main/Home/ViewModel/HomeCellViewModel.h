//
//  HomeCellViewModel.h
//  MobileProject
//
//  Created by wujunyang on 16/1/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"
#import "OrderModel.h"

@interface HomeCellViewModel : BaseViewModel

@property (nonatomic, copy, readonly) NSString *building_name;

@property (nonatomic, copy, readonly) NSString *district;

@property (nonatomic, copy, readonly) NSString *create_date;

@property (nonatomic, copy, readonly) NSString *house_usage;

@property (nonatomic, copy, readonly) NSString *house_address;

@property (nonatomic, copy, readonly) NSString *house_type;


- (instancetype)initWithModel:(OrderModel *)model;

@end
