//
//  HomeCellViewModel.m
//  MobileProject
//
//  Created by wujunyang on 16/1/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "HomeCellViewModel.h"

@interface HomeCellViewModel()
@property (nonatomic, strong) OrderModel *model;
@end

@implementation HomeCellViewModel

- (instancetype)initWithModel:(OrderModel *)model
{
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

-(NSString *)building_name
{
    return self.model.building_name;
}

-(NSString *)district
{
    return self.model.district;
}

-(NSString *)create_date
{
    return self.model.create_date;
}

-(NSString *)house_usage
{
    return self.model.house_usage;
}

-(NSString *)house_address
{
    return self.model.house_address;
}

-(NSString *)house_type
{
    return self.model.house_type;
}
@end
