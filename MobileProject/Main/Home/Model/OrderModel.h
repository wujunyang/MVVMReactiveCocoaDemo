//
//  OrderModel.h
//  MobileProject
//
//  Created by wujunyang on 16/1/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@protocol OrderModel
@end

@interface OrderModel : BaseModel

@property (nonatomic, copy) NSString<Optional> *building_name;

@property (nonatomic, copy) NSString<Optional> *district;

@property (nonatomic, copy) NSString<Optional> *create_date;

@property (nonatomic, copy) NSString<Optional> *house_usage;

@property (nonatomic, copy) NSString<Optional> *house_address;

@property (nonatomic, copy) NSString<Optional> *house_type;

@end
