//
//  QuestionCell.m
//  PatientClient
//
//  Created by dlz225 on 14-11-1.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import "QuestionCell.h"
#import "NSString+duan.h"


@implementation QuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubview];
    }
    return self;
}

- (void)initSubview
{
    UILabel *label1 = [[UILabel alloc] init];
    [label1 setFont:[UIFont systemFontOfSize:15]];
    label1.text = @"Question";
    label1.numberOfLines = 0;
    [self addSubview:label1];
    self.questionLabel = label1;
    
    UILabel *label2 = [[UILabel alloc] init];
    [label2 setFont:[UIFont systemFontOfSize:15]];
    label2.numberOfLines = 0;
    self.questionContentLabel = label2;
    [self addSubview:label2];
    
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    self.questionContentLabel.text = dict[@"question"];

    CGSize size = [NSString getSizeFromText:self.questionContentLabel.text ForFont:[UIFont systemFontOfSize:15] MaxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 70 - 10, MAXFLOAT)];
    self.questionContentLabel.frame = CGRectMake(70, 0, [UIScreen mainScreen].bounds.size.width - 70 - 10, size.height);
    self.questionLabel.frame = CGRectMake(0, 0, 65, size.height);
    self.cellHeight = size.height ;
}

//#pragma mark textview 计算文字高度改变控件高度
//- (void)textViewDidChange:(UITextView *)textView
//{
//    UIFont *font = [UIFont systemFontOfSize:15];
//    CGSize size = [NSString getSizeFromText:textView.text ForFont:font MaxSize:CGSizeMake(self.answer.frame.size.width - 20, 90)];
//    
//    // 内容为2行时
//    if (((int)size.height) / 20 == 2) {
//        
//        [self.inputView setFrame:CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44 - 15, [UIScreen mainScreen].bounds.size.width, size.height + 30)];
//        [self.answer setFrame:CGRectMake(2 * kGap, 7,[UIScreen mainScreen].bounds.size.width - 90 , 45)];
//        
//    }
//    // 内容大于2行时，显示3行内容
//    else if (((int)size.height) / 20 > 2)
//    {
//        [self.inputView setFrame:CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44 - 35, [UIScreen mainScreen].bounds.size.width, size.height + 30)];
//        [self.answer setFrame:CGRectMake(2 * kGap, 7,[UIScreen mainScreen].bounds.size.width - 90 , 65)];
//    }
//    // 内容为1行时
//    else
//    {
//        [self.answer setFrame:CGRectMake(2 * kGap, 7,[UIScreen mainScreen].bounds.size.width - 90 , 30)];
//        
//    }
//    
//}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
