//
//  startCell.m
//  PatientClient
//
//  Created by dlz225 on 14-10-22.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import "startCell.h"

@implementation startCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initCell];
    }
    return self;
}

- (void)initCell
{
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 30)];
    [label1 setFont:[UIFont systemFontOfSize:18]];
    [self.contentView addSubview:label1];
    self.doctorName = label1;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 110, 30)];
    [label2 setFont:[UIFont systemFontOfSize:15]];
    [self.contentView addSubview:label2];
    self.subject = label2;
    
    CGSize windowSize = [UIScreen mainScreen].bounds.size;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(windowSize.width - 85, 2, 80, 40)];
    // 设置成圆角
    [imgView.layer setMasksToBounds:YES];
    [imgView.layer setCornerRadius:5];
    [self addSubview:imgView];
    self.statesView = imgView;
}

- (void)awakeFromNib {
    // Initialization code
}

//@{@"doctName":@"Doctor A",@"subjects":@"风湿内科",@"status":@"on"}
- (void)setIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.dataArray[indexPath.row];
    self.doctorName.text = dict[@"doctName"];
    self.subject.text = dict[@"subjects"];
    NSString *s = dict[@"status"];
    if ([s isEqualToString:@"on"]) {
        self.statesView.image = [UIImage imageNamed:@"switch_on.png"];
    }
    else if ([s isEqualToString:@"off"])
    {
        self.statesView.image = [UIImage imageNamed:@"switch_off.png"];
    }
    UIImageView *background = [[UIImageView alloc] init];
    // 设置cell背景为圆角
    background.image = [[UIImage imageNamed:@"common_card_background@2x.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    self.backgroundView = background;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
