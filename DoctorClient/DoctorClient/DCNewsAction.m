//
//  DCNewsAction.m
//  DoctorClient
//
//  Created by JiangTeng on 14/10/29.
//  Copyright (c) 2014年 com.usc. All rights reserved.
//

#import "DCNewsAction.h"

#define kActionHeigt 125

@interface DCNewsAction ()
@property (nonatomic, copy) DCNewsActionBlock newsActionBlock;

@property (nonatomic, strong) UIView *actionView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *updateBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@end


@implementation DCNewsAction

- (id)init{
    self = [super init];
    if (self) {
        [self initSubview];
    }
    
    return self;
}

- (void)initSubview{
    
    self.tag = kTagNumReservedForExcludingViews;
    UIView *action = [[UIView alloc] init];
    [action setBackgroundColor:[UItils colorForHex:@"d1cecf" alpha:1.0]];
    [self addSubview:action];
    self.actionView = action;
    
    UIButton *deleteBtn = [[UIButton alloc] init];
    [deleteBtn setBackgroundColor:[UIColor whiteColor]];
    [deleteBtn setTitle:@"Delete News" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UItils colorForHex:@"595657" alpha:1.0] forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.actionView addSubview:deleteBtn];
    self.deleteBtn = deleteBtn;
    
    
    UIButton *updateBtn = [[UIButton alloc] init];
    [updateBtn setBackgroundColor:[UIColor whiteColor]];
    [updateBtn setTitle:@"Alter News" forState:UIControlStateNormal];
    [updateBtn setTitleColor:[UItils colorForHex:@"595657" alpha:1.0] forState:UIControlStateNormal];
    updateBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [updateBtn addTarget:self action:@selector(updateAction) forControlEvents:UIControlEventTouchUpInside];
    [self.actionView addSubview:updateBtn];
    self.updateBtn = updateBtn;
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UItils colorForHex:@"595657" alpha:1.0] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.actionView addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
    
}


- (void)deleteAction{
    self.newsActionBlock(DCNewsActionDelete);
    self.newsActionBlock = nil;
}

- (void)updateAction{
    self.newsActionBlock(DCNewsActionUpdate);
    self.newsActionBlock = nil;
}

- (void)cancelAction{
    self.newsActionBlock(DCNewsActionCancel);
    self.newsActionBlock = nil;
}



- (void)layoutSubviews{
    
    CGSize size = self.frame.size;
    
    
    self.deleteBtn.frame = CGRectMake(0, 0, size.width, 40);
    self.updateBtn.frame = CGRectMake(0, CGRectGetMaxY(self.deleteBtn.frame) + 1, size.width, 40);
    self.cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(self.updateBtn.frame) + 4, size.width, 40);
    
}



- (void)beginWithCompletion:(DCNewsActionBlock)completion{
    self.newsActionBlock = nil;
    self.newsActionBlock = completion;
    CGSize size = self.frame.size;
    
    self.actionView.frame = CGRectMake(0, size.height,size.width , kActionHeigt);
    [self setBackgroundColor:[UItils colorForHex:@"000000" alpha:0.0]];

    __block DCNewsAction *blockself = self;
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         
                         blockself.actionView.frame = CGRectMake(0, size.height - kActionHeigt,size.width , kActionHeigt);
                         [blockself setBackgroundColor:[UItils colorForHex:@"000000" alpha:0.5]];


                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.newsActionBlock(DCNewsActionCancel);
    self.newsActionBlock = nil;

}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
