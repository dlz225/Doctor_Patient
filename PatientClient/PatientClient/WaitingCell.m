//
//  WaitingCell.m
//  PatientClient
//
//  Created by dlz225 on 14-11-2.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import "WaitingCell.h"

@implementation WaitingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubview];
    }
    return self;
}

- (void)initSubview
{
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
