//
//  UserCell.m
//  PatientClient
//
//  Created by dlz225 on 14-10-20.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUserCell];
    }
    return self;
}


// WithFrame:CGRectMake(10, 0, 100, 44)
// WithFrame:CGRectMake(110, 8, [UIScreen mainScreen].bounds.size.width - 110 - 30, 30)

- (void)initUserCell
{
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:18]];
    label.numberOfLines = 0;
    self.title = label;
    [self.contentView addSubview:label];
    
    UITextView *textview = [[UITextView alloc] init];
    [textview setFont:[UIFont systemFontOfSize:15]];
    self.content = textview;
    [self.contentView addSubview:textview];
    
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    NSInteger num = self.titleArray.count - indexPath.row - 1;
    self.title.text = self.titleArray[num];
    self.content.text = self.contentArray[num];

    CGSize s = [NSString getSizeFromText:self.content.text ForFont:[UIFont systemFontOfSize:15] MaxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 110 - 30, MAXFLOAT)];

    if (s.height <= 44) {
        self.title.frame = CGRectMake(10, 0, 100, 44);
        self.content.frame = CGRectMake(110, 4, [UIScreen mainScreen].bounds.size.width - 110 - 30, 36);
    }
    else
    {
        self.title.frame = CGRectMake(10, 0, 100, s.height + 10);
        self.content.frame = CGRectMake(110, 0, [UIScreen mainScreen].bounds.size.width - 110 - 30, s.height + 10);
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
