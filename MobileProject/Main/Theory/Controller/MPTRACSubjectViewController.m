//
//  MPTRACSubjectViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/2.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPTRACSubjectViewController.h"

@interface MPTRACSubjectViewController ()

@end

@implementation MPTRACSubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor redColor];
    
    [self createSubject];
    
    [self createReplaySubject];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//RACSubject:信号提供者，自己可以充当信号，又能发送信号  使用场景:通常用来代替代理，有了它，就不必要定义代理了

// RACSubject使用步骤
// 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
// 2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
// 3.发送信号 sendNext:(id)value

// RACSubject:底层实现和RACSignal不一样。
// 1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
// 2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。

//RACSubject实例进行map操作之后, 发送完毕一定要调用-sendCompleted, 否则会出现内存泄漏; 而RACSignal实例不管是否进行map操作, 不管是否调用-sendCompleted, 都不会出现内存泄漏.
//原因 : 因为RACSubject是热信号, 为了保证未来有事件发生的时候, 订阅者可以收到信息, 所以需要对持有订阅者!

-(void)createSubject
{
    RACSubject *subject=[RACSubject subject];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"订阅者1的值%@",x);
    }];
    
    [subject sendNext:@"wujunyang"];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"订阅者2的值%@",x);
    }];
    
    [subject sendNext:@"cnblogs"];
    
//    输出：
//    订阅者1的值wujunyang
//    订阅者1的值cnblogs
//    订阅者2的值cnblogs
//    说明：RACSubject 发送过了sendNext  下面再去监听它是没有效果
    
//    RACSubject替代代理
    // 需求:
    // 1.给当前控制器添加一个按钮，modal到另一个控制器界面
    // 2.另一个控制器view中有个按钮，点击按钮，通知当前控制器
    
//    步骤一：在第二个控制器.h，添加一个RACSubject代替代理。
//    @interface TwoViewController : UIViewController
//    
//    @property (nonatomic, strong) RACSubject *delegateSignal;
//    
//    @end
//    
//    步骤二：监听第二个控制器按钮点击
//    @implementation TwoViewController
//    - (IBAction)notice:(id)sender {
//        // 通知第一个控制器，告诉它，按钮被点了
//        
//        // 通知代理
//        // 判断代理信号是否有值
//        if (self.delegateSignal) {
//            // 有值，才需要通知
//            [self.delegateSignal sendNext:nil];
//        }
//    }
//    @end
//    
//    步骤三：在第一个控制器中，监听跳转按钮，给第二个控制器的代理信号赋值，并且监听.
//    @implementation OneViewController
//    - (IBAction)btnClick:(id)sender {
//        
//        // 创建第二个控制器
//        TwoViewController *twoVc = [[TwoViewController alloc] init];
//        
//        // 设置代理信号
//        twoVc.delegateSignal = [RACSubject subject];
//        
//        // 订阅代理信号
//        [twoVc.delegateSignal subscribeNext:^(id x) {
//            
//            NSLog(@"点击了通知按钮");
//        }];
//        
//        // 跳转到第二个控制器
//        [self presentViewController:twoVc animated:YES completion:nil];
//        
//    }
//    @end
}


//RACReplaySubject 创建方法：
//（1）创建RACSubject
//（2）订阅信号
//（3）发送信号
//工作流程：
//（1）订阅信号时，内部保存了订阅者，和订阅者响应block
//（2）当发送信号的，遍历订阅者，调用订阅者的nextBlock
//（3）发送的信号会保存起来，当订阅者订阅信号的时，会将之前保存的信号，一个一个

//重复提供信号类，RACSubject的子类
//使用场景一:如果一个信号每被订阅一次，就需要把之前的值重复发送一遍，使用重复提供信号类
//使用场景二:可以设置capacity数量来限制缓存的value的数量,即只缓充最新的几个值


-(void)createReplaySubject
{
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"1 %@,type:%@",x,NSStringFromClass(object_getClass(x)));
    }];
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"1 %@,type:%@",x,NSStringFromClass(object_getClass(x)));
    }];
    [replaySubject sendNext:@1];
    
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"3 %@,type:%@",x,NSStringFromClass(object_getClass(x)));
    }];
    
    //输出
//    1 1,type:__NSCFNumber
//    1 1,type:__NSCFNumber
//    3 1,type:__NSCFNumber
//    说明：RACSubject必须要先订阅信号之后才能发送信号，而RACReplaySubject可以先发送信号后订阅.
}

@end
