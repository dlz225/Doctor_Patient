//
//  PCMainController.m
//  PatientClient
//
//  Created by dlz225 on 14-10-18.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import "PCMainController.h"
#import "PCMainModel.h"
#import "HomeController.h"
#import "PersonCenterController.h"
#import "LoginController.h"
#import "ResumeController.h"
#import "StartChatController.h"

@interface PCMainController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIView *mainView;
@property (nonatomic,strong) UITableView *controlTableView;
//@property (nonatomic,strong) NSMutableArray *controlArray;

@end

@implementation PCMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

+ (instancetype)shareMainViewController
{
    static PCMainController *mainViewController;
    static dispatch_once_t onecToken;
    
    dispatch_once(&onecToken, ^{
        mainViewController = [[PCMainController alloc] init];
    });
    
    return mainViewController;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self initMumber];
        [self initSubview];
        [self addController];
    }
    return self;
}

- (void)initMumber
{
    self.controlArray = [NSMutableArray array];
}

- (void)initSubview
{
    _mainView = [[UIView alloc] init];
    _mainView.frame = self.leftView.frame;
    [_mainView setBackgroundColor:[UIColor brownColor]];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(10, 50, 205, 400);
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.controlTableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [_mainView addSubview:tableView];
    [self initLeftview:_mainView];
}


- (void)addController
{
    HomeController *viewController = [[HomeController alloc] init];
    
    // 点击左上角按钮
    [viewController.leftItem addTarget:self action:@selector(leftItemClick:) forControlEvents:UIControlEventTouchUpInside];
    // Start New Chart 按钮
    [viewController.startButton addTarget:self action:@selector(startNewChat) forControlEvents:UIControlEventTouchUpInside];
    // Resume Previous Chart 按钮
    [viewController.resumeButton addTarget:self action:@selector(resumePreviousChat) forControlEvents:UIControlEventTouchUpInside];

    PCMainModel *home = [[PCMainModel alloc] init];
    home.control = [[UINavigationController alloc] initWithRootViewController:viewController];
    home.title = @"Home";
 
    
    StartChatController *viewController2 = [[StartChatController alloc] init];
    [viewController2.leftItem addTarget:self action:@selector(leftItemClick:) forControlEvents:UIControlEventTouchUpInside];
    PCMainModel *startNewChat = [[PCMainModel alloc] init];
    startNewChat.control = [[UINavigationController alloc] initWithRootViewController:viewController2];
    startNewChat.title = @"New Chat";
    
    ResumeController *viewController3 = [[ResumeController alloc] init];
    PCMainModel *resumeChat = [[PCMainModel alloc] init];
    resumeChat.control = viewController3;
    resumeChat.title = @"Resume Chat";
    [viewController3.leftItem addTarget:self action:@selector(leftItemClick:) forControlEvents:UIControlEventTouchUpInside];
    resumeChat.control = [[UINavigationController alloc] initWithRootViewController:viewController3];
    
    PersonCenterController *viewController4 = [[PersonCenterController alloc] init];
    PCMainModel *personCenter = [[PCMainModel alloc] init];
    [viewController4.leftItem addTarget:self
                                action:@selector(leftItemClick:)
                      forControlEvents:UIControlEventTouchUpInside];
    personCenter.control = [[UINavigationController alloc] initWithRootViewController:viewController4];
    personCenter.title = @"Person Center";
    
    LoginController *viewController5 = [[LoginController alloc] init];
    PCMainModel *signIn = [[PCMainModel alloc] init];
    signIn.control = [[UINavigationController alloc] initWithRootViewController:viewController5];
    signIn.title = @"Sign In";
    
    [self initCurrentView:home.control.view];
    [self.controlArray addObject:home];
    [self.controlArray addObject:startNewChat];
    [self.controlArray addObject:resumeChat];
    [self.controlArray addObject:personCenter];
    [self.controlArray addObject:signIn];
    
}

#pragma mark 监听start new chat按钮，实现跳转
- (void)startNewChat
{
    PCMainModel *model = _controlArray[1];
    [self didOpenViewController:model.control];
    [self leftItemClick:nil];
}

#pragma mark 监听Resume Previous Chat 按钮，实现跳转
- (void)resumePreviousChat
{
    PCMainModel *model = _controlArray[2];
    [self didOpenViewController:model.control];
    [self leftItemClick:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.controlArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentical = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentical];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentical];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    PCMainModel *model = _controlArray[indexPath.row];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel setFont:[UIFont systemFontOfSize:17]];
    cell.textLabel.text = model.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCMainModel *model = _controlArray[indexPath.row];
    [self didOpenViewController:model.control];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
