//
//  DrawerViewController.h
//  LetsGo
//
//  Created by JiangTeng on 14-7-22.
//  Copyright (c) 2014年 com.csu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kLeftWidth 200
#define kRightWidth 150

@interface DrawerViewController : UIViewController

@property (nonatomic, strong) UIView *currentView;
//@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIView *leftView;



- (void)panRecognized:(UIPanGestureRecognizer *)sender;
- (void)leftItemClick:(id)sender;
- (void)rightItemClick:(id)sender;


-(void)didOpenViewController:(UIViewController *)openView;
- (void)initLeftview:(UIView *)leftview;
- (void)initRightview:(UIView *)rightview;
- (void)initCurrentView:(UIView *)currentView;

- (void)addPan;
- (void)removePan;
@end
