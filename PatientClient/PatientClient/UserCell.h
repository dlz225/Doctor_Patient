//
//  UserCell.h
//  PatientClient
//
//  Created by dlz225 on 14-10-20.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+duan.h"

@interface UserCell : UITableViewCell

@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UITextView *content;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) NSMutableArray *contentArray;

@end
