//
//  PCWaitingController.m
//  PatientClient
//
//  Created by dlz225 on 14-11-2.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import "PCWaitingController.h"
#import "UserCell.h"
#import "PCAPIClient.h"
#import "DialogController.h"

#define kPropertyCount 9
#define kCellHeight 40
#define kGap 13

@interface PCWaitingController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UILabel *userNameLabel;
//@property (nonatomic,strong) UILabel *userRealNameLabel;
@property (nonatomic,strong) UITextField *ageTextField;
@property (nonatomic,strong) UITextField *sexTextField;
//@property (nonatomic,strong) UILabel *birthPlaceLabel;
//@property (nonatomic,strong) UILabel *userAddressLabel;
@property (nonatomic,strong) UIButton *photoPathBtn;  //用户头像
//@property (nonatomic,strong) UILabel *userTelLabel;

@property (nonatomic,strong) UIView *firstView; //包含头像、用户名、性别、年龄
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *personArray;
@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) NSMutableDictionary *userDict;
@property (nonatomic,strong) NSMutableDictionary *ohterDict;

@property (nonatomic,strong) UIButton *deleteBtn;  //删除该医生
@property (nonatomic,strong) UIButton *seeDoctorBtn;  //看病
@property (nonatomic,strong) UIView *thirdView;

@property (nonatomic,assign) BOOL canEdit;  // 是否能修改状态
@end

@implementation PCWaitingController

- (id)init
{
    if (self = [super init]) {
        [self initNavigationUI];
        [self addSubviews];
        
        // 创建用户基本信息界面
        //        [self initUserUI];
    }
    return self;
}

- (void)initNavigationUI
{
    // 标题
    self.title = @"Person Center";
    
    
    // 左边按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"navigationbar_back.png"];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    UIImage *image2 = [UIImage imageNamed:@"navigationbar_back.png"];
    [btn setBackgroundImage:image2 forState:UIControlStateHighlighted];
    btn.bounds = (CGRect){CGPointZero,image.size};
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    
    
}

- (void)addSubviews
{
    self.canEdit = NO;
    // 第三块区域
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 44, [UIScreen mainScreen].bounds.size.width, 44)];
    [vv setBackgroundColor:[UIColor colorWithRed:240/255 green:240/255 blue:240/255 alpha:0.01]];
    [self.view addSubview:vv];
    self.thirdView = vv;
    
    // 设置底部固定按钮--delete ， see the doctor
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 2 - 1, 44)];
    [btn1 setTitle:@"Delete" forState:UIControlStateNormal];
    [btn1.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [btn1 addTarget:self action:@selector(DeleteDoctor) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.thirdView addSubview:btn1];
    self.deleteBtn = btn1;
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 + 1, 0, [UIScreen mainScreen].bounds.size.width / 2, 44)];
    [btn2 setTitle:@"See the Doctor" forState:UIControlStateNormal];
    [btn2.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [btn2 addTarget:self action:@selector(SeeDoctor) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.thirdView addSubview:btn2];
    self.deleteBtn = btn2;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44)];
    // 设置滚动size
    self.scrollView.contentSize = CGSizeMake(0, self.scrollView.frame.size.height +0.5);
    [self.view addSubview:self.scrollView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // 确定view
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(kGap, 0, [UIScreen mainScreen].bounds.size.width - 2 * kGap, 120)];
    //    [v1 setBackgroundColor:[UIColor redColor]];
    self.firstView = v1;
    [self.scrollView addSubview:v1];
    
    // 确定tableView
    UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(kGap, CGRectGetMaxY(self.firstView.frame) +2, [UIScreen mainScreen].bounds.size.width - 2 * kGap, [UIScreen mainScreen].bounds.size.height - 120)];
    
    tabView.delegate = self;
    tabView.dataSource = self;
    [self.scrollView addSubview:tabView];
    self.tableView = tabView;
    
    // 设置头像
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = CGRectMake(kGap, kGap, 80, 80);
    // 设置成圆角
    [imageBtn.layer setMasksToBounds:YES];
    [imageBtn.layer setCornerRadius:40];
    
    [imageBtn setBackgroundImage:[UIImage imageNamed:self.userDict[@"patientPhoto"]] forState:UIControlStateNormal];
//    [imageBtn addTarget:self action:@selector(changeIcon) forControlEvents:UIControlEventTouchUpInside];
    [self.firstView addSubview:imageBtn];
    
    self.photoPathBtn = imageBtn;
    
    // 设置用户名
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(120, kGap, 100,kCellHeight)];
    label1.text = self.userDict[@"patientId"];
    [label1 setFont:[UIFont systemFontOfSize:20]];
    label1.textAlignment = NSTextAlignmentLeft;
    [self.firstView addSubview:label1];
    self.userNameLabel = label1;
    
    //    // 设置年龄
    //    UITextField *f1 = [[UITextField alloc] initWithFrame:CGRectMake(160, kGap + 40, 40,kCellHeight)];
    //    f1.text = [NSString stringWithFormat:@"%@",dict[@"age"]];
    //    [f1 setFont:[UIFont systemFontOfSize:17]];
    //    f1.enabled = _canEdit;
    //    [self.firstView addSubview:f1];
    //    self.ageTextField = f1;
    
    // 设置性别
    UITextField *f2 = [[UITextField alloc] initWithFrame:CGRectMake(120, kGap + 40, 80,kCellHeight)];
    [f2 setFont:[UIFont systemFontOfSize:17]];
    f2.enabled = NO;
    [self.firstView addSubview:f2];
    self.sexTextField = f2;
    
}

- (void)DeleteDoctor
{
    NSLog(@"delete!!!");
}

- (void)SeeDoctor
{
    DialogController *dialog = [[DialogController alloc] init];
    [self.navigationController pushViewController:dialog animated:YES];
}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)SignOut
{
    NSLog(@"sign out!!!");
}

#pragma mark 设置titleArray数据
- (void)initTitleArray
{
    self.titleArray = [NSMutableArray array];
    [self.titleArray addObject:@"Name"];
    [self.titleArray addObject:@"Birth"];
    [self.titleArray addObject:@"Telephone"];
    [self.titleArray addObject:@"Email"];
    [self.titleArray addObject:@"Address"];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //    NSLog(@"%@",self.userDict);
    
    [self initUserUI];

}

- (void)initUserUI
{
    __block PCWaitingController *blockself = self;
    // 获取个人信息
    [[PCAPIClient sharedAPIClient] getPath:@"patient!queryByUserId"parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"-----成功！！");
        
        blockself.userDict = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"patientInfo"]];
        blockself.personArray = [NSMutableArray arrayWithObjects:blockself.userDict[@"patientName"],blockself.userDict[@"patientBirth"],blockself.userDict[@"patientTel"],blockself.userDict[@"patientEmail"],blockself.userDict[@"patientAddress"],nil];
        
        // 在这里设置相应的属性
        dispatch_async(dispatch_get_main_queue(), ^{
            [blockself initTitleArray];
            blockself.sexTextField.text = [blockself.userDict objectForKey:@"patientSex"];
            blockself.userNameLabel.text = [blockself.userDict objectForKey:@"patientId"];
            blockself.photoPathBtn.imageView.image = [UIImage imageNamed:[blockself.userDict objectForKey:@"patientId"]];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"-----失败！！");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.personArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentical = @"personCell";
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentical];
    if (!cell) {
        cell = [[UserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentical];
        cell.titleArray = self.titleArray;
        cell.contentArray = self.personArray;
    }
    
    cell.indexPath = indexPath;
    cell.content.editable = _canEdit;
    cell.content.tag = indexPath.row;
    if (cell.content.editable == YES) {
        // 设置边框
        cell.content.layer.borderWidth = 1.0;
        cell.content.layer.borderColor = [[UIColor grayColor] CGColor];
        cell.content.layer.cornerRadius = 5.0;
    }
    else
    {
        cell.content.layer.borderWidth = 0;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = self.personArray[indexPath.row];
    CGSize siz = [NSString getSizeFromText:str ForFont:[UIFont systemFontOfSize:15] MaxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 110 - 30, MAXFLOAT)];
    if (siz.height + 15 <= 44) {
        return 44;
    }
    else
    {
        return siz.height + 15;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
