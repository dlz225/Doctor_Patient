//
//  DCNewsTableViewCell.m
//  DoctorClient
//
//  Created by JiangTeng on 14/10/28.
//  Copyright (c) 2014年 com.usc. All rights reserved.
//

#import "DCNewsTableViewCell.h"
@interface DCNewsTableViewCell ()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *createTime;
@property (nonatomic, strong) UIButton *iconBtn;


@end

@implementation DCNewsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        [self initSubview];
    }
    
    return self;
}


- (void)initSubview {
    
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = kNewsFont;
    label.numberOfLines = 0;
    label.textColor = [UItils colorForHex:@"535353" alpha:1.0];
    [self addSubview:label];
    self.contentLabel = label;
    
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    btn.contentEdgeInsets = UIEdgeInsetsMake(2, 5, 13, 5);
//    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    self.iconBtn = btn;
    
    
    UILabel *time = [[UILabel alloc] init ];
    time.backgroundColor = [UIColor clearColor];
    time.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:time];
    self.createTime = time;
    
}


- (void)btnAction{
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:self.model forKey:kNewsActionModel];
    
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"newstapAction" object:para];
}



- (void)layoutSubviews{
    CGSize size = self.frame.size;
    self.iconBtn.frame = CGRectMake(size.width - 60, 0, 35, 40);
    self.createTime.frame = CGRectMake(size.width-80, self.model.height * 0.5, 100, 15);
}


- (void)setModel:(DCNewsModel *)model{
    _model = model;
    
    
    
    self.contentLabel.text = model.content;
    self.createTime.text = [UItils parseLongDate:model.startTime];
 
    self.contentLabel.frame = CGRectMake(10, 5, kNewsWeight, model.height);
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the  selected state
}

@end
