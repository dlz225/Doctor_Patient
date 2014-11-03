//
//  DCMainViewController.m
//  DoctorClient
//test
//  Created by JiangTeng on 14-10-16.
//  Copyright (c) 2014年 com.usc. All rights reserved.
//

#import "DCMainViewController.h"
#import "ViewController.h"
#import "DCMainModel.h"
#import "DCHomeViewController.h"
#import "SettingViewController.h"
#import "DCQuestionsViewController.h"
#import "DCWaitingRoomViewController.h"


@interface DCMainViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) NSMutableArray *controllersArray;
@property (nonatomic, strong) UITableView *controlTableView;

@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UILabel *lineLabel;
@end

@implementation DCMainViewController

#pragma mark shareController

+ (instancetype)shareMainViewController{
    static DCMainViewController *mainViewController;
    static dispatch_once_t onecToken;
    
    dispatch_once(&onecToken, ^{
        mainViewController = [[DCMainViewController alloc] init];
    });
    
    return mainViewController;
}

- (void)initSubview{
    UIView *mainView = [[UIView alloc] init];
    mainView.frame = self.leftView.frame;
    [mainView setBackgroundColor:[UIColor brownColor]];
    self.mainView = mainView;
    
    
    
    UIImageView *imageview= [[UIImageView alloc] init];
    [imageview setBackgroundColor:[UIColor clearColor]];
    imageview.image = [UIImage imageNamed:@"offline"] ;
    [self.mainView addSubview:imageview];
    self.lineImageView = imageview;
    self.lineImageView.frame = CGRectMake(30, 40, 40, 40);
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize:17];
    label.text = @"On Line";
    [self.mainView addSubview:label];
    self.lineLabel = label;
    self.lineLabel.frame = CGRectMake(CGRectGetMaxX(self.lineImageView.frame) + 15 , CGRectGetMinY(self.lineImageView.frame) + 10, 100, 20);
    
    
    UITableView *tableview = [[UITableView alloc] init];
    [tableview setBackgroundColor:[UIColor clearColor]];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.frame = CGRectMake(20, 100, 200, 400);
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.mainView addSubview:tableview];
    self.controlTableView = tableview;
    
    
    
    
    [self initLeftview:self.mainView];
}

- (void)initMumber{
    self.controllersArray = [NSMutableArray array];
}


- (void)addController{
    
    DCHomeViewController *homeviewcontroller = [[DCHomeViewController alloc] init];
    [homeviewcontroller.leftButton addTarget:self
                                      action:@selector(leftItemClick:)
                            forControlEvents:UIControlEventTouchUpInside];
    
    DCMainModel *model1 = [[DCMainModel alloc] init];
    UINavigationController *navigationHome = [[UINavigationController alloc] initWithRootViewController:homeviewcontroller];
    navigationHome.navigationBar.tag = kTagNumReservedForExcludingViews;

    model1.control = navigationHome;
    model1.title = @"Home";
    
    
    
    DCWaitingRoomViewController *waitingRoom = [[DCWaitingRoomViewController alloc] init];
    [waitingRoom.leftButton addTarget:self
                               action:@selector(leftItemClick:)
                     forControlEvents:UIControlEventTouchUpInside];

    UINavigationController *navigationRM = [[UINavigationController alloc] initWithRootViewController:waitingRoom];
    navigationRM.navigationBar.tag = kTagNumReservedForExcludingViews;
    
    DCMainModel *modelWR = [[DCMainModel alloc] init];
    modelWR.control = navigationRM;
    modelWR.title = @"Waiting Room";
    
    
    DCQuestionsViewController *questionsVC = [[DCQuestionsViewController alloc] init];
    [questionsVC.leftButton addTarget:self
                               action:@selector(leftItemClick:)
                     forControlEvents:UIControlEventTouchUpInside];
    
    UINavigationController *navigationQuest = [[UINavigationController alloc] initWithRootViewController:questionsVC];
    navigationQuest.navigationBar.tag = kTagNumReservedForExcludingViews;

    DCMainModel *questmodel = [[DCMainModel alloc] init];
    questmodel.control = navigationQuest;
    questmodel.title = @"Triage Questions";
    
    
    
    SettingViewController *settingviewcontroller = [[SettingViewController alloc] init];
    [settingviewcontroller.leftButton addTarget:self action:@selector(leftItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UINavigationController *navigationSetting = [[UINavigationController alloc] initWithRootViewController:settingviewcontroller];
    navigationSetting.navigationBar.tag = kTagNumReservedForExcludingViews;
    
    DCMainModel *signInModel = [[DCMainModel alloc] init];
    signInModel.control = navigationSetting;
    signInModel.title = @"Setting";
    
    
    
    [self initCurrentView:navigationHome.view];
    [self.controllersArray addObject:model1];
    [self.controllersArray addObject:modelWR];
    [self.controllersArray addObject:questmodel];
    [self.controllersArray addObject:signInModel];
}


#pragma mark table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.controllersArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"DCMainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    DCMainModel *model = self.controllersArray[indexPath.row];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.textLabel.text = model.title;
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DCMainModel *model = self.controllersArray[indexPath.row];
    
    [self didOpenViewController:model.control];
}



#pragma mark self method

- (id)init{
    self = [super init];
    if (self) {
        [self initMumber];
        [self initSubview];
        [self addController];
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
