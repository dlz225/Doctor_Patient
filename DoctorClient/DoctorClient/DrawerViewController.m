//
//  DrawerViewController.m
//  LetsGo
//
//  Created by JiangTeng on 14-7-22.
//  Copyright (c) 2014年 com.csu. All rights reserved.
//

#import "DrawerViewController.h"

#define kNeedRestoreWidth 120
#define kNeedAdjustDx 6
#define kNeedAdjustAlpha 0.7



@interface DrawerViewController ()<UIGestureRecognizerDelegate>
{
    // 刚开始按下去时的x
    CGFloat _lastDownX;
    
    CGFloat _leftWidth;
    CGFloat _leftHeight;
    
    CGFloat _rightWidth;
    CGFloat _rightHeight;
    CGFloat _rightOrighX;
}
@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@end

@implementation DrawerViewController

- (id) init{
    self = [super init];
    if (self) {
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        
        //init subview
        self.leftView = [[UIView alloc] init];
        self.leftView.frame = CGRectMake(0, 0, kLeftWidth, screenBounds.size.height);
        self.leftView.clipsToBounds = YES;
        [self.view addSubview:self.leftView];
        
//        self.rightView = [[UIView alloc] init];
//        self.rightView.frame =  CGRectMake(screenBounds.size.width - kRightWidth, 0, kRightWidth, screenBounds.size.height);
//        self.rightView.clipsToBounds = YES;
//        [self.view addSubview:self.rightView];
        
        self.currentView = [[UIView alloc]init];
        self.currentView.frame = screenBounds;
        [self.view addSubview:self.currentView];
        
        
//        _rightHeight = self.rightView.frame.size.height;
//        _rightWidth  = self.rightView.frame.size.width;
//        _rightOrighX = self.rightView.frame.origin.x;
        
        _leftWidth = self.leftView.frame.size.width;
        _leftHeight = self.leftView.frame.size.height;
        
        // 添加手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognized:)];
        pan.delegate = self;
        [self.currentView addGestureRecognizer:pan];
        self.pan = pan;
    }
    return  self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return !(touch.view.tag == kTagNumReservedForExcludingViews);
}


- (void)addPan{
    [self.currentView removeGestureRecognizer:self.pan];
    [self.currentView addGestureRecognizer:self.pan];
}

- (void)removePan{
    [self.currentView removeGestureRecognizer:self.pan];
}

- (void)initLeftview:(UIView *)leftview{
    [self.leftView addSubview:leftview];
}

- (void)initRightview:(UIView *)rightview{
//    [self.rightView addSubview:rightview];
}

- (void)initCurrentView:(UIView *)currentView{
    [self.currentView addSubview:currentView];
}


-(void)didOpenViewController:(UIViewController *)openView
{
    
    if (self.currentView.subviews.count > 0) {
        UIView *old = self.currentView.subviews[0];
        [old removeFromSuperview];
    }
    openView.view.frame = self.currentView.bounds;
    [self.currentView addSubview:openView.view];
    
    [self leftItemClick:nil];
}


#pragma mark 监听手势拖动过程
- (void)panRecognized:(UIPanGestureRecognizer *)sender {
    
    // 1.保留刚按下去时，contentView的x
    if (UIGestureRecognizerStateBegan == sender.state) {
        _lastDownX = self.currentView.frame.origin.x;
    }
    // 2.根据挪动的距离设置contentView的frame
    CGPoint translation = [sender translationInView:self.currentView];
    CGRect frame = self.currentView.frame;
    frame.origin.x = _lastDownX + translation.x;
    
    // 3.判断contentView有没有超出左边的屏幕
    if (frame.origin.x < -_rightWidth)
    {
        frame.origin.x = -_rightWidth;
    } else if (frame.origin.x > _leftWidth) {
        frame.origin.x = _leftWidth;
    }
    self.currentView.frame = frame;
    // 0.如果手势结束了，就要决定往哪边缩
    if (UIGestureRecognizerStateEnded == sender.state) {
        CGFloat x = self.currentView.frame.origin.x;
        
        // 需要归0的情况：往左边挪了一点、往右边挪了一点
        if (   (x <= 0 && x >= -_rightWidth * 0.5)
            || (x>=0 && x <= _leftWidth * 0.5) )
        {
            // 归0
            x = 0;
        } else if (x >= -_rightWidth && x <= -_rightWidth * 0.5) {
            // 回归最左边
            x = -_rightWidth;
        } else if (x >= _leftWidth * 0.5 && x <= _leftWidth) {
            // 回归最右边
            x = _leftWidth;
        }
        
        // 设置contentView的frame
        frame.origin.x = x;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2f];
        self.currentView.frame = frame;
        [UIView commitAnimations];
        // 不要执行后面的代码
    }
    // 4.根据拖动的方向来决定隐藏哪边的抽屉
    if (frame.origin.x < 0) {
        
        self.leftView.hidden = YES;
//        self.rightView.hidden = NO;
        [self changeViewFrameAndAlpha:self.currentView.frame isLeft:NO];//向左拖
    } else {
        self.leftView.hidden = NO;
//        self.rightView.hidden = YES;
        [self changeViewFrameAndAlpha:self.currentView.frame isLeft:YES];//向右拖
    }
}


#pragma mark 改变frame使得动画
- (void)changeViewFrameAndAlpha:(CGRect )currentViewFrame isLeft:(BOOL)isLeft
{
    
    float proportion;
    if (isLeft)
    {
        proportion = _leftWidth - currentViewFrame.origin.x;
    } else
    {
        proportion = _rightWidth + currentViewFrame.origin.x;
    }
    
    float ratio = proportion / ([[UIScreen mainScreen] bounds].size.width);
    
    currentViewFrame.origin.y = kNeedAdjustDx * ratio;
    
    if (isLeft)
    {
        currentViewFrame.origin.x = kNeedAdjustDx * ratio;
        currentViewFrame.size.width = _leftWidth- kNeedAdjustDx * ratio * 2;
        currentViewFrame.size.height = _leftHeight  - kNeedAdjustDx * ratio * 2;
        [self.leftView setFrame:currentViewFrame];
    } else
    {
        currentViewFrame.size.width = _rightWidth- kNeedAdjustDx * ratio * 2;
        currentViewFrame.size.height = _rightHeight  - kNeedAdjustDx * ratio * 2;
        currentViewFrame.origin.x = self.view.frame.size.width - kNeedAdjustDx * ratio - currentViewFrame.size.width ;
        
//        [self.rightView setFrame:currentViewFrame];
    }
}


#pragma mark item点击的公共代码
- (void)itemClick:(BOOL)isLeft
{
    
    
    // 1.取出frame值
    CGRect frame = self.currentView.frame;
    
    if (0 == frame.origin.x) {
        [self changeViewFrameAndAlpha:frame isLeft:isLeft];
        frame.origin.x = isLeft ? _leftWidth :-(_rightWidth);
    } else {
        frame.origin.x = 0;
    }
    // 2.重新赋值frame
    
    
    __block DrawerViewController *blockself = self;
    [UIView animateWithDuration:0.5f
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionLayoutSubviews animations:^{
                            blockself.currentView.frame = frame;
                            if (frame.origin.x == 0) {
                                [blockself changeViewFrameAndAlpha:frame isLeft:isLeft];
                            } else
                            {
                                if (isLeft)
                                {
                                    blockself.leftView.frame = CGRectMake(0, 0, _leftWidth, _leftHeight);
                                } else
                                {
                                    //            self.rightView.frame = CGRectMake(_rightOrighX, 0, _rightWidth, _rightHeight);
                                }
                            }
                            
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark 点击左边的item按钮
- (void)leftItemClick:(id)sender {
    self.leftView.hidden = NO;
//    self.rightView.hidden = YES;
    [self itemClick:YES];
}

#pragma mark 点击右边的item按钮
- (void)rightItemClick:(id)sender {
//    self.rightView.hidden = NO;
    self.leftView.hidden = YES;
    [self itemClick:NO];
}


@end
