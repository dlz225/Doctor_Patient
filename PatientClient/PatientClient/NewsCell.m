//
//  NewsCell.m
//  PatientClient
//
//  Created by dlz225 on 14-10-28.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initCell];
    }
    
    return self;
}

- (void)initCell
{
    UILabel *label1 = [[UILabel alloc] init];
    label1.numberOfLines = 0;
    self.content = label1;
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.numberOfLines = 0;
    self.publishTime = label2;
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.numberOfLines = 0;
    self.publishman = label3;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
