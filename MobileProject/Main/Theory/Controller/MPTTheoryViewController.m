//
//  MPTTheoryViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/1.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPTTheoryViewController.h"

@interface MPTTheoryViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) NSArray             *dataArray;
@property (nonatomic,strong) UITableView         *myTableView;
@end

@implementation MPTTheoryViewController

//常见的五个宏

//1：
//RAC(TARGET, [KEYPATH, [NIL_VALUE]]):用于给某个对象的某个属性绑定
// 只要文本框文字改变，就会修改label的文字
//RAC(self.labelView,text) = _textField.rac_textSignal;

//2:
//RACObserve(self, name):监听某个对象的某个属性,返回的是信号。
//[RACObserve(self.view, center) subscribeNext:^(id x) {
//    NSLog(@"%@",x);
//}];


//当RACObserve放在block里面使用时一定要加上weakify，不管里面有没有使用到self；否则会内存泄漏，因为RACObserve宏里面就有一个self
//@weakify(self);
//RACSignal *signal3 = [anotherSignal flattenMap:^(NSArrayController *arrayController) {
    // Avoids a retain cycle because of RACObserve implicitly referencing self
//    @strongify(self);
//    return RACObserve(arrayController, items);
//}];

//3:
//@weakify(Obj)和@strongify(Obj),一般两个都是配套使用,在主头文件(ReactiveCocoa.h)中并没有导入，需要自己手动导入，RACEXTScope.h才可以使用。但是每次导入都非常麻烦，只需要在主头文件自己导入就好了

//4:
//RACTuplePack：把数据包装成RACTuple（元组类）
// 把参数中的数据包装成元组
//RACTuple *tuple = RACTuplePack(@10,@20);

//5:
//RACTupleUnpack：把RACTuple（元组类）解包成对应的数据
//// 把参数中的数据包装成元组
//RACTuple *tuple = RACTuplePack(@"xmg",@20);
//
//// 解包元组，会把元组的值，按顺序给参数里面的变量赋值
//// name = @"xmg" age = @20
//RACTupleUnpack(NSString *name,NSNumber *age) = tuple;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"基础知识点";
    
    if (!self.dataArray) {
        self.dataArray=@[@"RACSigner基础知识点",@"RACSubject基础知识点",@"RACSequence基础知识点",@"RACCommand基础知识点",@"RACMulticastConnection基础知识点",@"RAC结合UI一般事件",@"高阶操作知识内容",@"RAC并发编程知识点",@"冷信号跟热信号知识点",@"RACDisposable知识点",@"RACChannel知识点",@"RAC倒计时小实例"];
    }
    
    //初始化表格
    if (!_myTableView) {
        _myTableView                                = [[UITableView alloc] initWithFrame:CGRectMake(0,0.5, Main_Screen_Width, Main_Screen_Height) style:UITableViewStylePlain];
        _myTableView.showsVerticalScrollIndicator   = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.dataSource                     = self;
        _myTableView.delegate                       = self;
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [self.view addSubview:_myTableView];
        [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }

}

#pragma mark UITableViewDataSource, UITableViewDelegate相关内容

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.accessoryType    = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text   = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            MPTRACSignerViewController *vc=[[MPTRACSignerViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
        {
            MPTRACSubjectViewController *vc=[[MPTRACSubjectViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:
        {
            MPTRACSequenceViewController *vc=[[MPTRACSequenceViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:
        {
            MPTRACCommandViewController *vc=[[MPTRACCommandViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4:
        {
            MPTRACMulticastConnectionViewController *vc=[[MPTRACMulticastConnectionViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5:
        {
            MPTRACUIKitViewController *vc=[[MPTRACUIKitViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            case 6:
        {
            MPTRACHightSignalViewController *vc=[[MPTRACHightSignalViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            case 7:
        {
            MPTRACSchedulerViewController *vc=[[MPTRACSchedulerViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 8:
        {
            MPTHotAndColdSignalViewController *vc=[[MPTHotAndColdSignalViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 9:
        {
            MPTRACDisposableViewController *vc=[[MPTRACDisposableViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 10:
        {
            RACChannelViewController *vc=[[RACChannelViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 11:
        {
            MPTCountDownViewController *vc=[[MPTCountDownViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}
@end
