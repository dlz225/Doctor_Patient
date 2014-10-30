//
//  ChatCell.m
//  PatientClient
//
//  Created by dlz225 on 14-10-23.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import "ChatCell.h"
#import "NSString+duan.h"

@implementation ChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initChatCell];
    }
    
    return self;
}

- (void)initChatCell
{
    UILabel *label1 = [[UILabel alloc] init];
    [label1 setNumberOfLines:0];
    [label1 setFont:[UIFont systemFontOfSize:15]];
    self.userLabel = label1;
    [self.contentView addSubview:label1];
    
    UITextView *textview = [[UITextView alloc] init];
    textview.editable = NO;
    textview.bounces = NO;
    textview.scrollsToTop = YES;
//    textview.scrollEnabled = NO;
    textview.contentSize = CGSizeMake(0, 0);
    textview.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    textview.contentOffset = CGPointMake(0, 10);
    [textview setFont:[UIFont systemFontOfSize:15]];
    self.contentTextView = textview;
    [self addSubview:textview];
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = _dataArray[indexPath.row];
    self.userLabel.text = dict[@"user"];
    self.contentTextView.text = dict[@"content"];
    CGSize s = [NSString getSizeFromText:self.contentTextView.text ForFont:[UIFont systemFontOfSize:15] MaxSize:CGSizeMake(180, MAXFLOAT)];
    
    if (s.height <= 44) {
        self.contentTextView.frame = CGRectMake(90, 2, [UIScreen mainScreen].bounds.size.width - 20 - 90 - 4, 40);
        self.userLabel.frame = CGRectMake(10,0, 80, 44);
    }
    else
    {
        self.contentTextView.frame = CGRectMake(90, 0, [UIScreen mainScreen].bounds.size.width - 20 - 90 - 4, s.height + 18);
        self.userLabel.frame = CGRectMake(10,0, 80, s.height + 15);
    }
    [self.contentTextView scrollRangeToVisible:NSMakeRange([self.contentTextView.text length] - 1, 0)];

    
    //设置cell背景
    UIImageView *background = [[UIImageView alloc] init];
    // 设置cell背景为圆角
    background.image = [[UIImage imageNamed:@"common_card_background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    self.backgroundView = background;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
