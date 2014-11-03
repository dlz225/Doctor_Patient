//
//  PersonCenterController.h
//  PatientClient
//
//  Created by dlz225 on 14-10-20.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface PersonCenterController : UIViewController 

@property (nonatomic, strong) UIButton *leftItem;
@property (nonatomic,strong) User *user;
@property (nonatomic,strong) UIScrollView *scrollView;

@end
