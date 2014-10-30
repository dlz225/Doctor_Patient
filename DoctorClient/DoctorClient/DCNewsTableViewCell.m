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
    label.font = [UIFont systemFontOfSize:11];
    label.numberOfLines = 0;
    [self addSubview:label];
    self.contentLabel = label;
    
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    self.iconBtn = btn;
    
    
    UILabel *time = [[UILabel alloc] init ];
    time.backgroundColor = [UIColor clearColor];
    time.font = [UIFont systemFontOfSize:12];
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
    self.iconBtn.frame = CGRectMake(size.width - 80, 5, 100, 10);
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

    // Configure the view for the selected state
}

@end
