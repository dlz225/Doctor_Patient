//
//  PCWaitingController.h
//  PatientClient
//
//  Created by dlz225 on 14-11-2.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface PCWaitingController : UIViewController

@property (nonatomic,strong) UIButton *leftItem;
@property (nonatomic,strong) User *user;
@property (nonatomic,strong) UIScrollView *scrollView;

@end
