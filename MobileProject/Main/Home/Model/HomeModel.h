//
//  HomeModel.h
//  MobileProject
//
//  Created by wujunyang on 16/1/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "OrderModel.h"

@interface HomeModel : BaseModel

@property (nonatomic, strong) NSNumber *status;

@property (nonatomic, copy) NSString<Optional> *message;

@property (nonatomic, strong) NSNumber *page_index;

@property (nonatomic, strong) NSNumber *total_count;

@property (nonatomic, strong) NSNumber *page_size;

@property(nonatomic,strong) NSArray<Optional,OrderModel> *order_list;

@end
