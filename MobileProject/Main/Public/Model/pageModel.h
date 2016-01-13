//
//  pageModel.h
//  MobileProject 分页的实体
//
//  Created by wujunyang on 16/1/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pageModel : NSObject

/**
 *  当前页条数
 */
@property (nonatomic, assign) NSInteger page_size;

/**
 *  当前页码
 */
@property (nonatomic, assign) NSInteger page_index;

/**
 *  总记录数
 */
@property (nonatomic, assign) NSInteger total_count;

@end
