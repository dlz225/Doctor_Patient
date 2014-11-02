//
//  DialogController.h
//  PatientClient
//
//  Created by dlz225 on 14-10-23.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DialogController : UIViewController

@property (nonatomic,strong) UIButton *leftItem;
@property (nonatomic,strong) UILabel *subjectContentLabel;
@property (nonatomic,strong) UILabel *doctorContentLabel;
@property (nonatomic,strong) UILabel *patientContentLabel;
@property (nonatomic,copy) NSString *doctorName;
@end
