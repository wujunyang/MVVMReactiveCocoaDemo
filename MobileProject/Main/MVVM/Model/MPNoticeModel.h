//
//  MPNoticeModel.h
//  MobileProject
//
//  Created by wujunyang on 2017/3/24.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MPNoticeModel <NSObject>

@end

@interface MPNoticeModel :JSONModel

@property (nonatomic,copy,readwrite) NSString<Optional> *notice_title;

@property (nonatomic,copy,readwrite) NSString<Optional> *create_date;

@property (nonatomic,copy,readwrite) NSString<Optional> *notice_type;

@property (nonatomic,copy,readwrite) NSString<Optional> *notice_content;

@property (nonatomic,copy,readwrite) NSString<Optional> *publish_date;

@property (nonatomic,copy,readwrite) NSString<Optional> *create_by;

@property (nonatomic,copy,readwrite) NSString<Optional> *notice_url;

@property (nonatomic,copy,readwrite) NSString<Optional> *publish_department_name;

@end
