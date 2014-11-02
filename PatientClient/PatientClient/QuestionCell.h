//
//  QuestionCell.h
//  PatientClient
//
//  Created by dlz225 on 14-11-1.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kGap 15
@interface QuestionCell : UITableViewCell <UITextViewDelegate>

@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic,strong) UILabel *questionLabel;
@property (nonatomic,strong) UILabel *questionContentLabel;
@property (nonatomic,strong) UITextView *answer;
@property (nonatomic,assign) CGFloat cellHeight;
@end
