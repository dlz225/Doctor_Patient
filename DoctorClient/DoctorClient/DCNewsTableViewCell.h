//
//  DCNewsTableViewCell.h
//  DoctorClient
//
//  Created by JiangTeng on 14/10/28.
//  Copyright (c) 2014年 com.usc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCNewsModel.h"

#define kNewsActionModel @"newsactionmodel"

@interface DCNewsTableViewCell : UITableViewCell

@property (nonatomic, strong) DCNewsModel *model;

@end
