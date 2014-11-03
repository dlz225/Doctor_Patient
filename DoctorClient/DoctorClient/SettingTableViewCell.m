//
//  SettingTableViewCell.m
//  DoctorClient
//
//  Created by JiangTeng on 14/10/30.
//  Copyright (c) 2014年 com.usc. All rights reserved.
//

#import "SettingTableViewCell.h"

@interface SettingTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel     *iconLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end


@implementation SettingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [self addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *iconLabel = [[UILabel alloc] init];
    iconLabel.backgroundColor = [UIColor clearColor];
    iconLabel.font = [UIFont boldSystemFontOfSize:16];
    iconLabel.textColor = [UItils colorForHex:@"343434" alpha:1];
    iconLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:iconLabel];
    self.iconLabel = iconLabel;
    
    UILabel *dataLabel = [[UILabel alloc] init];
    dataLabel.backgroundColor = [UIColor clearColor];
    dataLabel.textColor = [UItils colorForHex:@"8f8f95" alpha:1];
    dataLabel.textAlignment = NSTextAlignmentRight;
    dataLabel.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:dataLabel];
    self.dataLabel = dataLabel;
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = [UIImage imageNamed:@"settings_arrow"];
    [self addSubview:arrowImageView];
    self.arrowImageView = arrowImageView;
    self.arrowImageView.hidden = YES;
    
}

- (void)updateIconImageName:(NSString*)imageName
               andIconLabel:(NSString*)iconTitle
                    andData:(NSString*)data
               andShowArrow:(BOOL)isShowArow;
{
    CGFloat originY =7;
    CGFloat height = 30;
    if (imageName && ![imageName isEqual:@""]) {
        self.iconImageView.image = [UIImage imageNamed:imageName];
        self.iconImageView.frame = CGRectMake(15, originY, 30, height);
        self.iconLabel.frame = CGRectMake(55, originY, 200, height);
        self.dataLabel.frame = CGRectMake(140, originY, 150, height);
    }
    else
    {
        self.iconLabel.frame = CGRectMake(10, originY, 200, height);
        self.dataLabel.frame = CGRectMake(150, originY, 140, height);
    }
    
    self.iconLabel.text = iconTitle;
    self.dataLabel.text = data;
    
    self.arrowImageView.hidden = !isShowArow;
}

- (void)layoutSubviews{
    CGSize size = self.frame.size;
    self.arrowImageView.frame = CGRectMake(size.width-30, 15, 10, 15);

}

- (void)updateData:(NSString*)data
{
    self.dataLabel.text = data;
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
