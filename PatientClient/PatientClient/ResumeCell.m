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
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(52, 5, 60, 18)];
    [label1 setFont:[UIFont systemFontOfSize:15]];
    label1.text = @"Doctor:";
    label1.numberOfLines = 0;
    [self.contentView addSubview:label1];
    self.doctorLabel = label1;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(115, 5, 120, 18)];
    [label2 setFont:[UIFont systemFontOfSize:15]];
    label2.numberOfLines = 0;
    [self.contentView addSubview:label2];
    self.doctorNameLabel = label2;
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(52, 25, 60, 18)];
    [label3 setFont:[UIFont systemFontOfSize:15]];
    label3.text = @"Subject:";
    label3.numberOfLines = 0;
    [self.contentView addSubview:label3];
    self.topicLabel = label3;
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(115, 25, 120, 18)];
    [label4 setFont:[UIFont systemFontOfSize:15]];
    label4.numberOfLines = 0;
    [self.contentView addSubview:label4];
    self.topicContentLabel = label4;
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 75, 5, 70, 18)];
    [label5 setFont:[UIFont systemFontOfSize:12]];
    label5.numberOfLines = 0;
    label5.textAlignment = NSTextAlignmentCenter;
    [label5 setTextColor:[UIColor grayColor]];
    [self addSubview:label5];
    self.timeLabel = label5;
    
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.resumeArray[indexPath.row];
    self.doctorNameLabel.text = dict[@"doctor"];
    self.topicContentLabel.text = dict[@"subject"];
    self.timeLabel.text = dict[@"time"];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
