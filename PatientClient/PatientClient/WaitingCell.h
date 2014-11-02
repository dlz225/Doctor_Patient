//
//  WaitingCell.h
//  PatientClient
//
//  Created by dlz225 on 14-11-2.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitingCell : UITableViewCell

@property (nonatomic,strong) UILabel *doctor;
@property (nonatomic,strong) UILabel *subject;
@property (nonatomic,strong) UILabel *lastTime;
@property (nonatomic,strong) UILabel *lastMessage;
@property (nonatomic,strong) UIButton *stateBtn;


@end
