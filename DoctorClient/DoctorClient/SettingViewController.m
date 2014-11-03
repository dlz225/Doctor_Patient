//
//  SettingViewController.m
//  DoctorClient
//
//  Created by JiangTeng on 14/10/30.
//  Copyright (c) 2014年 com.usc. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"

typedef NS_ENUM (NSInteger, SettingsType) {
    SettingsTypeHelp,
    SettingsTypeAgreement,
    SettingsTypePolicy,
    SettingsTypeAbout,
    SettingsTypeMyProfile,
    SettingsTypeNone
};

@interface SettingViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *exitBtn;
@property (nonatomic, strong) UITableView *settingsTableView;

@property (nonatomic, strong) NSArray *dataArr;


@end




@implementation SettingViewController

- (id)init{
    self = [super init];
    if (self) {
        [self initMumber];
        [self initSubviews];
    }
    
    return self;
}

- (void)initMumber{
    NSArray *dataArr = @[
                         @[@{@"type":@(SettingsTypeMyProfile),
                             @"imageName": @"itemProfileMe" ,
                             @"title": @"My Profile",
                             @"showArrow":@(YES)},
                            @{@"type":@(SettingsTypePolicy),
                             @"imageName": @"privacy_policy" ,
                             @"title": @"Privacy Policy",
                             @"showArrow":@(YES)},
                           @{@"type":@(SettingsTypeAgreement),
                             @"imageName": @"license_agreement" ,
                             @"title": @"License Agreement",
                             @"showArrow":@(YES)}],
                         
                         @[@{@"type":@(SettingsTypeHelp),
                             @"title": @"Tech Help",
                             @"showArrow":@(NO)},
                           @{@"type":@(SettingsTypeAbout),
                             @"title": @"About App",
                             @"showArrow":@(YES)}],
                         @[@{@"type":@(SettingsTypeNone),
                             @"imageName": @"" ,
                             @"title": @"",
                             @"showArrow":@(NO)}]];
    
    self.dataArr = dataArr;
}


- (void)initSubviews
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"navigationbar"];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    UIImage *imageHight = [UIImage imageNamed:@"navigationbar_Hight"];
    [btn setBackgroundImage:imageHight forState:UIControlStateHighlighted];
    btn.bounds = (CGRect){CGPointZero,image.size};
    self.leftButton = btn;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setBackgroundColor:[UItils colorForHex:@"efeff4" alpha:1]];
    scrollView.bounces = YES;
    scrollView.clipsToBounds = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UITableView *settingsTableView = [[UITableView alloc] init];
    settingsTableView.dataSource = self;
    settingsTableView.delegate = self;
    settingsTableView.bounces = NO;
    settingsTableView.scrollEnabled = NO;
    [self.scrollView addSubview:settingsTableView];
    self.settingsTableView = settingsTableView;
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.contentMode = UIViewContentModeCenter;
    [exitBtn setTitle:@"Log Out" forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [exitBtn setBackgroundImage:[UIImage imageNamed:@"CellSingle"]
                       forState:UIControlStateNormal];
    [exitBtn setBackgroundImage:[UIImage imageNamed:@"CellSingleHighlighted"]
                       forState:UIControlStateHighlighted];
    exitBtn.titleLabel.textColor = [UItils colorForHex:@"000000" alpha:1];
    exitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [exitBtn addTarget:self
                action:@selector(exitCurrentTapped)
      forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:exitBtn];
    self.exitBtn = exitBtn;
}

- (void)exitCurrentTapped{
    
}



#pragma mark - tableview deletage


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return [self.dataArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [[self.dataArr objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identifier = @"DCSettingCell";
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row >= [[self.dataArr objectAtIndex:indexPath.section] count]) {
        return cell;
    }
    
    NSString *imageName = [[[self.dataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"imageName"];
    NSString *title = [[[self.dataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
    NSString *data = [[[self.dataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"data"];
    BOOL isShow = [[[[self.dataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"showArrow"] boolValue];
    
    [cell updateIconImageName:imageName
                 andIconLabel:title
                      andData:data
                 andShowArrow:isShow];
    return cell;
}




- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UItils colorForHex:@"efeff4" alpha:1];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    CGFloat row = 0;
    if (section != 0) {
        row =  20;
    }
    return row;
}




#pragma mark - setup subview Frame

#define itemsCount 5

- (void)setupSubviewFrame
{
    CGSize size = self.view.bounds.size;
    
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(320, self.scrollView.frame.size.height+0.5);

    CGFloat y = 44 * itemsCount +  20;
    self.settingsTableView.frame = CGRectMake(0, 50, size.width, y);
    self.exitBtn.frame = CGRectMake((size.width - 280) *0.5, size.height - 44 -50, 280, 44);
}


#pragma mark self method

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"Setting";
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupSubviewFrame];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupSubviewFrame];
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
