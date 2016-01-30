//
//  HomeTableViewCell.m
//  MobileProject
//
//  Created by wujunyang on 16/1/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "HomeTableViewCell.h"

@interface HomeTableViewCell()
@property(strong,nonatomic)UIView *leftColorView;
@property(strong,nonatomic)UILabel *nameLabel;
@property(strong,nonatomic)UIButton *goButton;
@end

//左边色彩条宽度
static const CGFloat leftColorViewWidth=2;
//文字字体大小
static const CGFloat textFontSize=14;

@implementation HomeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //设置背影色
        self.backgroundColor=RGB(255, 255, 255);
        self.accessoryType = UITableViewCellAccessoryNone;
        
        if (self.leftColorView==nil) {
            self.leftColorView=[[UIView alloc]init];
            self.leftColorView.backgroundColor=[UIColor redColor];
            [self.contentView addSubview:self.leftColorView];
            [self.leftColorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView.mas_left).with.offset(0);
                make.top.mas_equalTo(self.contentView.mas_top).with.offset(0);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(0);
                make.width.mas_equalTo(leftColorViewWidth);
            }];
        }
        
        if (self.nameLabel==nil) {
            self.nameLabel=[[UILabel alloc]init];
            self.nameLabel.font=CHINESE_SYSTEM(textFontSize);
            self.nameLabel.textColor=[UIColor blueColor];
            self.nameLabel.textAlignment=NSTextAlignmentLeft;
            self.nameLabel.numberOfLines=0;
            [self.nameLabel sizeToFit];
            [self.contentView addSubview:self.nameLabel];
            [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView).with.offset(0);
                make.left.mas_equalTo(self.contentView.mas_left).with.offset(15);
                make.right.mas_equalTo(self.contentView.mas_right).with.offset(-15);
            }];
        }
        
        if(!self.goButton)
        {
            self.goButton=[[UIButton alloc]init];
            [self.goButton setTitle:@"跳转" forState:UIControlStateNormal];
            self.goButton.backgroundColor=[UIColor blueColor];
            [self.contentView addSubview:self.goButton];
            [self.goButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView).with.offset(0);
                make.right.mas_equalTo(self.contentView.mas_right).with.offset(-15);
                make.size.mas_equalTo(CGSizeMake(80, 30));
            }];
        }
        
        //直接绑定  这边有个注意Racobserve 左边只有self  右边才有viewModel.building_name  这样就避CELL 重用的问题
        RAC(self.nameLabel,text)=RACObserve(self, viewModel.building_name);
        
        //rac_prepareForReuseSignal很重要  如果不加takeUntil:cell.rac_prepareForReuseSignal，那么每次Cell被重用时，该button都会被addTarget:selector
        [[[self.goButton
           rac_signalForControlEvents:UIControlEventTouchUpInside]
           takeUntil:self.rac_prepareForReuseSignal]
           subscribeNext:^(id x) {
             NSLog(@"cell 跳转");
         }];
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
