//
//  StartChatController.m
//  PatientClient
//
//  Created by dlz225 on 14-10-22.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import "StartChatController.h"
#import "PersonCenterController.h"
#import "startCell.h"
#import "PCWaitingController.h"
#import "SearchController.h"

@interface StartChatController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,strong) UIView *editView;
@property (nonatomic,strong) UIButton *addBtn;
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,assign) BOOL canEdit;  // 是否能修改状态

@end

@implementation StartChatController

- (id)init
{
    if (self = [super init]) {
        // 创建基本界面
        [self initUI];
        
        [self addData];
        
        self.canEdit = NO;
    }
    return self;
}

- (void)initUI
{
    // 标题
    self.title = @"New Chat";
    
    // 左边按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"navigationbar_pop.png"];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    UIImage *image2 = [UIImage imageNamed:@"navigationbar_pop_highlighted.png"];
    [btn setBackgroundImage:image2 forState:UIControlStateSelected];
    btn.bounds = (CGRect){CGPointZero,image.size};
    self.leftItem = btn;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(Search)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
//    
//    // editView 及其子控件
//    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 2 * 15, 60)];
//    v1.hidden = YES;
////    [v1 setBackgroundColor:[UIColor redColor]];
//    self.editView = v1;
//    [self.scrollView addSubview:v1];
//    
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn1.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 2 * 15 - 110, 5, 60, 44);
//    [btn1 setTitle:@"Add" forState:UIControlStateNormal];
//    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [btn1 addTarget:self action:@selector(addCell) forControlEvents:UIControlEventTouchUpInside];
//    self.addBtn = btn1;
//    [self.editView addSubview:btn1];
//    
//    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn2.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 2 * 15 - 60, 5, 60, 44);
//    [btn2 setTitle:@"Delete" forState:UIControlStateNormal];
//    [btn2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [btn2 addTarget:self action:@selector(deleteCell) forControlEvents:UIControlEventTouchUpInside];
//    self.deleteBtn = btn2;
//    [self.editView addSubview:btn2];
    
    // tableview
    UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 60) style:UITableViewStylePlain];
    // 去掉灰色下划线
    tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabView.dataSource = self;
    tabView.delegate = self;
    [self.view addSubview:tabView];
    self.tableView = tabView;

    // 下拉刷新
    __unsafe_unretained StartChatController *blockSelf = self;
    [self.tableView setPullToRefreshHandler:^{
        [blockSelf pullToRefresh];
    }];
    [self.tableView setPullToRefreshViewActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.tableView setPullToRefreshViewPullingText:@"pull loading..."];
    [self.tableView setPullToRefreshViewReleaseText:@"let go load..."];
    [self.tableView setPullToRefreshViewLoadingText:@"loading..."];
    [self.tableView setPullToRefreshViewLoadedText:@""];
    
}
- (void)pullToRefresh{
    __block StartChatController *blockself =self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [blockself addData];
        [blockself.tableView refreshFinished];
    });
}

#pragma mark - Search 按钮
- (void)Search
{
    SearchController *search = [[SearchController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

//- (void)addCell
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add A New Doctor" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(alert.center.x + 20, alert.center.y + 10, 169, 30)];
//    [alert addSubview:field];
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    [alert show];
//}

//- (void)deleteCell
//{
//    self.canEdit = !self.canEdit;
//    [self.tableView setEditing:self.canEdit animated:YES];
//    
//    // 更改edit按钮样式
//    if (self.editView.hidden == YES) {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(RightButton)];
//    }
//    else
//    {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(RightButton)];
//    }
//}

#pragma mark edit操作
//- (void)RightButton
//{
//    

    
//    //  设置动画
//    self.editView.hidden = !self.editView.hidden;
//    if (self.editView.hidden == NO) {
//        self.editView.backgroundColor = [UIColor grayColor];
//        self.editView.frame = CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 2 * 15, 0);
////        self.editView.alpha = 0;
//        [UIView beginAnimations:nil context:nil];
//        self.editView.frame = CGRectMake(15, 5, [UIScreen mainScreen].bounds.size.width - 2 * 15, 50);
////        self.editView.alpha = 1;
//        [UIView setAnimationDuration:1.5f];
//        [UIView commitAnimations];
//    }
//    else
//    {
//        [UIView beginAnimations:nil context:nil];
//        self.editView.frame = CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 2 * 15, 0);
////        self.editView.alpha = 0;
//        [UIView setAnimationDuration:1.5f];
//        [UIView commitAnimations];
//
//        self.canEdit = NO;
//        [self.tableView setEditing:self.canEdit animated:YES];
//    }
//}

- (void)addData
{
    // 初始化数组
    NSArray *Arr = @[@{@"doctName":@"Doctor A",@"subjects":@"风湿内科",@"status":@"off"},@{@"doctName":@"Doctor B",@"subjects":@"关节炎",@"status":@"on"},@{@"doctName":@"Doctor C",@"subjects":@"眼科",@"status":@"on"},@{@"doctName":@"Doctor D",@"subjects":@"骨科",@"status":@"off"}];
    _array = [NSMutableArray arrayWithArray:Arr];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 判断是否是ios7以上，调整下拉刷新的边界
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentical = @"startCell";
    startCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentical];
    if (!cell) {
        cell = [[startCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentical];
        cell.dataArray = self.array;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //self.array[indexPath.row];
    
    cell.indexPath = indexPath;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCWaitingController *dialog = [[PCWaitingController alloc] init];
//    startCell *start = (startCell *)[tableView cellForRowAtIndexPath:indexPath];
//    dialog.doctorContentLabel.text = start.doctorName.text;
//    dialog.subjectContentLabel.text = start.subject.text;
    [self.navigationController pushViewController:dialog animated:YES];
}

#pragma mark 当用户提交了一个编辑操作就会调用（比如点击了“删除”按钮）
// 只要实现了这个方法，就会默认添加滑动删除功能
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果是删除操作
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // 1.删除模型数据
        [self.array removeObjectAtIndex:indexPath.row];
        
        // 2.刷新表格
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {

    }
    else
        return;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // OK 按钮
    if (buttonIndex == 1) {
        
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

@end
