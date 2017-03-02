//
//  MPTRACSequenceViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/2.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPTRACSequenceViewController.h"

@interface MPTRACSequenceViewController ()

@end

@implementation MPTRACSequenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self createSequence];
    
    [self createSequenceOperation];
    
    [self createRACTuple];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//RACSequence:RAC中的集合类，用于代替NSArray,NSDictionary,可以使用它来快速遍历数组和字典

//通过RACSequence对数组进行操作
// 这里其实是三步
// 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
// 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
// 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
-(void)createSequence
{
    NSArray *arr = @[@1,@2,@3,@4,@5,@6];
    [arr.rac_sequence.signal subscribeNext:^(id x) {
        
        NSLog(@"当前的值x:%@",x);
    }];
    //输出
//    当前的值x:1
//    当前的值x:2
//    当前的值x:3
//    当前的值x:4
//    当前的值x:5
//    当前的值x:6
    
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"jtd",@"name",@"man",@"sex",@"jx",@"jg", nil];
    [dict.rac_sequence.signal subscribeNext:^(id x) {
        RACTupleUnpack(NSString *key,NSString *value) = x;
        
        NSLog(@"key:%@,value:%@",key,value);
    }];
    //输出：
//    key:name,value:jtd
//    key:sex,value:man
//    key:jg,value:jx
    
    NSDictionary *dict1 = @{@"key1":@"value1",@"key2":@"value2"};
    NSDictionary *dict2 = @{@"key1":@"value1",@"key2":@"value2"};
    NSArray *dictArr = @[dict1,dict2];
    [dictArr.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"x:%@,type:%@",x,NSStringFromClass(object_getClass(x)));
    }];
    //输出
//x:{
//    key1 = value1;
//    key2 = value2;
//},type:__NSDictionaryI
//}
//
//x:{
//    key1 = value1;
//    key2 = value2;
//},type:__NSDictionaryI
}



//可以对数组进行map,filter,reduce,skip,take,contact..操作
-(void)createSequenceOperation
{
    NSArray *array=@[@(2),@(5),@(7),@(15)];
    RACSequence *sequence = [array rac_sequence];
    id mapData = [sequence map:^id(id value) {
        return @([value integerValue] * 2);
    }];
    NSLog(@"序列Map之后的数据:%@",[mapData array]);
    
    id filterData = [sequence filter:^BOOL(id value) {
        return [value integerValue]%2 == 0;
    }];
    NSLog(@"序列Filter之后的数据:%@",[filterData array]);
    
    id reduceData = [sequence foldLeftWithStart:@"" reduce:^id(id accumulator, id value) {
        return [accumulator stringByAppendingString:[value stringValue]];
    }];
    NSLog(@"序列Left-Reduce之后的数据:%@",reduceData);
    
    id rightReduceData = [sequence foldRightWithStart:@"" reduce:^id(id first, RACSequence *rest) {
        return [NSString stringWithFormat:@"%@%@", rest.head, first];
    }];
    NSLog(@"序列Right-Reduce之后的数据:%@",rightReduceData);
    
    id skipData = [sequence skip:1];
    NSLog(@"序列Skip之后的数据:%@",[skipData array]);
    
    
    id takeData = [sequence take:2];
    NSLog(@"序列Take之后的数据:%@",[takeData array]);
    
    id takeUntilData = [sequence takeUntilBlock:^BOOL(id x) {
        return [x integerValue] == 7;
    }];
    NSLog(@"序列TakeUntil之后的数据:%@",[takeUntilData array]);
    
    NSArray *nextArr = @[@"A",@"B",@"C"];
    RACSequence *nextSequence = [nextArr rac_sequence];
    id contactData = [sequence concat:nextSequence];
    NSLog(@"FlyElephant序列Contact之后的数据:%@",[contactData array]);
    
    //输出
//    序列Map之后的数据:(
//                                           4,
//                                           10,
//                                           14,
//                                           30
//                                           )
//    序列Filter之后的数据:(
//                                                                      2
//                                                                      )
//    序列Left-Reduce之后的数据:25715
//    序列Right-Reduce之后的数据:15752
//    序列Skip之后的数据:(
//                                                                    5,
//                                                                    7,
//                                                                    15
//                                                                    )
//    序列Take之后的数据:(
//                                                                    2,
//                                                                    5
//                                                                    )
//    序列TakeUntil之后的数据:(
//                                                                         2,
//                                                                         5
//                                                                         )
//    FlyElephant序列Contact之后的数据:(
//                                                                                  2,
//                                                                                  5,
//                                                                                  7,
//                                                                                  15,
//                                                                                  A,
//                                                                                  B,
//                                                                                  C
//                                                                                  )
}


//RACTuple
//可用下标访问元素 （实现了objectAtIndexedSubscript:方法）
//可用for in枚举（遵循NSFastEnumeration协议）
//可跟NSArray互相转换
//可转换为RACSequence
//可把NSNull.null转为RACTupleNil.tupleNil
-(void)createRACTuple
{
    //普通创建
    RACTuple *tuple1 = [RACTuple tupleWithObjects:@1, @2, @3, nil];
    RACTuple *tuple2 = [RACTuple tupleWithObjectsFromArray:@[@1, @2, @3]];
    RACTuple *tuple3 = [[RACTuple alloc] init];
    
    //宏创建
    RACTuple *tuple4 = RACTuplePack(@1, @2, @3, @4);
    
    //解包(等号前面是参数定义，后面是已存在的Tuple，参数个数需要跟Tuple元素相同）
    RACTupleUnpack(NSNumber * value1, NSNumber * value2, NSNumber * value3, NSNumber * value4) = tuple4;
    NSLog(@"%@ %@ %@ %@", value1, value2, value3, value4);
    
    //元素访问方式
    NSLog(@"%@", [tuple4 objectAtIndex:1]);
    NSLog(@"%@", tuple4[1]);
    
    //输出
    //1 2 3 4
    //2
    //2
}

@end
