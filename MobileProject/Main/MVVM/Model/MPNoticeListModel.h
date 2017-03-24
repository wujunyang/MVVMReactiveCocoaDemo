//
//  MPNoticeListModel.h
//  MobileProject
//
//  Created by wujunyang on 2017/3/24.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "MPNoticeModel.h"

@interface MPNoticeListModel : BaseModel

@property(nonatomic,copy)NSArray<Optional,MPNoticeModel> *list;

@end
