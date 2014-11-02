//
//  ResumeCell.m
//  PatientClient
//
//  Created by dlz225 on 14-10-21.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import "ResumeCell.h"

@implementation ResumeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 初始化cell
        [self initResumeCell];
    }
    return self;
}

- (void)initResumeCell
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(7,7, 36, 36)];
    [btn setBackgroundImage:[UIImage imageNamed:@"ditu_ic.png"] forState:UIControlStateNormal];
    // 设置成圆角
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:18];
    [self.contentView addSubview:btn];
    self.iconBtn = btn;
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 5, 70, 18)];
    [label5 setFont:[UIFont systemFontOfSize:12]];
    label5.numberOfLines = 0;
    label5.textAlignment = NSTextAlignmentCenter;
    [label5 setTextColor:[UIColor grayColor]];
    [self addSubview:label5];
    self.timeLabel = label5;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 25, 48, 18)];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    button.enabled = NO;
    // 设置成圆角
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:3];
    [self addSubview:button];
    self.state = button;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconBtn.frame) + 8, 5, CGRectGetMinX(self.timeLabel.frame) - CGRectGetMaxX(self.iconBtn.frame) - 8, 18)];
    [label2 setFont:[UIFont systemFontOfSize:15]];
//    label2.numberOfLines = 0;
    [self.contentView addSubview:label2];
    self.doctorNameLabel = label2;
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconBtn.frame) + 8, 25, CGRectGetMinX(self.timeLabel.frame) - CGRectGetMaxX(self.iconBtn.frame) - 8, 18)];
    [label4 setFont:[UIFont systemFontOfSize:15]];
    
    label4.numberOfLines = 0;
    [self.contentView addSubview:label4];
    self.topicContentLabel = label4;
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 30, 25, 18, 18)];
    [button1.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    button1.enabled = NO;
    // 设置成圆角
    [button1.layer setMasksToBounds:YES];
    [button1.layer setCornerRadius:9];
    [self addSubview:button1];
    self.notReadMsgBtn = button1;
}

- (void)setDict:(NSMutableDictionary *)dict
{
    _dict = dict;
    
    self.doctorNameLabel.text = dict[@"doctor"];
    self.topicContentLabel.text = dict[@"subject"];
    self.timeLabel.text = dict[@"time"];
    NSString *state = dict[@"state"];
    if ([state isEqualToString:@"waiting"]) {
        [self.state setBackgroundColor:[UIColor orangeColor]];
        [self.state setTitle:@"Waiting" forState:UIControlStateNormal];
    }
    else if ([state isEqualToString:@"on"])
    {
        [self.state setBackgroundColor:[UIColor greenColor]];
        [self.state setTitle:@"On" forState:UIControlStateNormal];
    }
    else if ([state isEqualToString:@"over"])
    {
        [self.state setBackgroundColor:[UIColor redColor]];
        [self.state setTitle:@"Over" forState:UIControlStateNormal];
    }
    
    NSString *newsCount = dict[@"newMsg"];
    if (![newsCount isEqualToString:@"0"]) {
        [self.notReadMsgBtn setBackgroundColor:[UIColor redColor]];
        [self.notReadMsgBtn setTitle:newsCount forState:UIControlStateNormal];
    }
    else
    {
        [self.notReadMsgBtn setBackgroundColor:[UIColor whiteColor]];
        [self.notReadMsgBtn setTitle:@"" forState:UIControlStateNormal];
    }

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
