//
//  DCMainViewController.m
//  DoctorClient
//
//  Created by JiangTeng on 14-10-16.
//  Copyright (c) 2014年 com.usc. All rights reserved.
//

#import "DCMainViewController.h"
#import "ViewController.h"
#import "DCMainModel.h"


@interface DCMainViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) NSMutableArray *controllersArray;
@property (nonatomic, strong) UITableView *controlTableView;
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
    
    UITableView *tableview = [[UITableView alloc] init];
    [tableview setBackgroundColor:[UIColor clearColor]];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.frame = CGRectMake(20, 50, 150, 400);
    
    [self.mainView addSubview:tableview];
    self.controlTableView = tableview;
    
    
    [self initLeftview:self.mainView];
}

- (void)initMumber{
    self.controllersArray = [NSMutableArray array];
}


- (void)addController{
    ViewController *viewcontroller = [[ViewController alloc] init];
    
    DCMainModel *model1 = [[DCMainModel alloc] init];
    model1.control = viewcontroller;
    model1.title = @"Home";
    
    UIViewController *waitingRoom = [[UIViewController alloc] init];
    [waitingRoom.view setBackgroundColor:[UIColor blueColor]];
    
    DCMainModel *model2 = [[DCMainModel alloc] init];
    model2.control = waitingRoom;
    model2.title = @"Waiting Room";
    
    
    UIViewController *labOrders = [[UIViewController alloc] init];
    [labOrders.view setBackgroundColor:[UIColor grayColor]];
    
    DCMainModel *labmodel = [[DCMainModel alloc] init];
    labmodel.control = labOrders;
    labmodel.title = @"Lab Orders";
    
    UIViewController *signIn = [[UIViewController alloc] init];
    [signIn.view setBackgroundColor:[UIColor greenColor]];
    
    DCMainModel *signInModel = [[DCMainModel alloc] init];
    signInModel.control = signIn;
    signInModel.title = @"Sign In";
    
    
    
    [self initCurrentView:viewcontroller.view];
//    [self initRightview:nil];
    [self.controllersArray addObject:model1];
    [self.controllersArray addObject:model2];
    [self.controllersArray addObject:labmodel];
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
