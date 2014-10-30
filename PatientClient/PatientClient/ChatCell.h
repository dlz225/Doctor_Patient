//
//  ChatCell.h
//  PatientClient
//
//  Created by dlz225 on 14-10-23.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell

@property (nonatomic,strong) UILabel *userLabel;
@property (nonatomic,strong) UITextView *contentTextView;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end
