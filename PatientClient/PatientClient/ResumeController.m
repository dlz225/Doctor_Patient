//
//  ResumeController.m
//  PatientClient
//
//  Created by dlz225 on 14-10-21.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import "ResumeController.h"
#import "ResumeCell.h"
#import "ChatController.h"
#import "UIScrollView+AH3DPullRefresh.h"

@interface ResumeController ()

@property (nonatomic,assign) BOOL canEdit;  // 是否能修改状态
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation ResumeController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        [self initUI];
        self.canEdit = NO;
    }
    return self;
}

- (void)initUI
{
    // 标题
    self.title = @"Chat";
    
    // 左边按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"navigationbar_pop.png"];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    UIImage *image2 = [UIImage imageNamed:@"navigationbar_pop_highlighted.png"];
    [btn setBackgroundImage:image2 forState:UIControlStateHighlighted];
    btn.bounds = (CGRect){CGPointZero,image.size};
    self.leftItem = btn;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(rightButton)];

    self.tableView.userInteractionEnabled = YES;
    
    // 下拉刷新
    __unsafe_unretained ResumeController *blockSelf = self;
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
    __block ResumeController *blockself =self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [blockself addData];
        [blockself.tableView reloadData];
        [blockself.tableView refreshFinished];
    });
    
}

- (void)addData
{
    // 初始化数组
    _dataArray = [NSMutableArray array];
    for (int i = 0; i < 1; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"Doctor A" forKey:@"doctor"];
        [dict setObject:@"hello！！！" forKey:@"subject"];
        [dict setObject:@"11" forKey:@"newMsg"];
        [dict setObject:@"2014-10-02" forKey:@"time"];
        [dict setObject:@"on" forKey:@"state"];

        [_dataArray addObject:dict];
    }
    for (int i = 0; i < 1; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"Doctor B" forKey:@"doctor"];
        [dict setObject:@"what！！" forKey:@"subject"];
        [dict setObject:@"11" forKey:@"newMsg"];
        [dict setObject:@"2014-10-03" forKey:@"time"];
        [dict setObject:@"waiting" forKey:@"state"];
        
        [_dataArray addObject:dict];
    }
    for (int i = 0; i < 1; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"Doctor C" forKey:@"doctor"];
        [dict setObject:@"hehe！！" forKey:@"subject"];
        [dict setObject:@"0" forKey:@"newMsg"];
        [dict setObject:@"2014-11-1" forKey:@"time"];
        [dict setObject:@"over" forKey:@"state"];
        
        [_dataArray addObject:dict];
    }
}

#pragma mark edit按钮
- (void)rightButton
{
    self.canEdit = !_canEdit;
    [self.tableView setEditing:self.canEdit animated:YES];
    
    // 更改edit按钮样式
    if (self.canEdit == YES) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(rightButton)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(rightButton)];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addData];

    // 判断是否是ios7以上，调整下拉刷新的边界
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentical = @"resumeCell";
    ResumeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentical];
    if (!cell) {
        cell = [[ResumeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentical];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.resumeArray = self.dataArray;
    }
    
    cell.dict = self.dataArray[indexPath.row];
    cell.accessoryView.hidden = self.canEdit;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 将新消息改为0
    NSMutableDictionary *dict = self.dataArray[indexPath.row];
    [dict setObject:@"0" forKey:@"newMsg"];
    [self.tableView reloadData];
    // 压入新控制器
    ChatController *chat = [[ChatController alloc] init];
    [self.navigationController pushViewController:chat animated:YES];
}

#pragma mark 当用户提交了一个编辑操作就会调用（比如点击了“删除”按钮）
// 只要实现了这个方法，就会默认添加滑动删除功能
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果不是删除操作，直接返回
    if (editingStyle != UITableViewCellEditingStyleDelete) return;
    
    // 1.删除模型数据
    [self.dataArray removeObjectAtIndex:indexPath.row];
    
    // 2.刷新表格
    //    [tableView reloadData];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

@end
