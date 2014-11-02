//
//  ResumeCell.h
//  PatientClient
//
//  Created by dlz225 on 14-10-21.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResumeCell : UITableViewCell

@property (nonatomic,strong) UIButton *iconBtn;     // 头像
@property (nonatomic,strong) UILabel *doctorLabel;      // 医生
@property (nonatomic,strong) UILabel *doctorNameLabel;  // 医生名字
@property (nonatomic,strong) UILabel *topicLabel;       //主题
@property (nonatomic,strong) UILabel *topicContentLabel;        // 主题内容
@property (nonatomic,strong) UILabel *tipsLabel;        // 建议
@property (nonatomic,strong) UILabel *timeLabel;    // 时间
@property (nonatomic,strong) NSMutableDictionary *dict;
@property (nonatomic,strong) UIButton *state;     // 状态
@property (nonatomic,strong) UIButton *notReadMsgBtn;     // 新消息



@end
