//
//  DCHomeViewController.m
//  DoctorClient
//
//  Created by JiangTeng on 14/10/27.
//  Copyright (c) 2014年 com.usc. All rights reserved.
//

#import "DCNewsModel.h"
#import "DCHomeViewController.h"
#import "DCNewsTableViewCell.h"
#import "DCNewsAction.h"
#import "DCADDNewsViewController.h"

@interface DCHomeViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong) UITableView *newsTableview;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) DCNewsAction *newsActionView;
@property (nonatomic, strong) DCNewsModel *selectModel;



@end

@implementation DCHomeViewController



- (id)init{
    self = [super init];
    if (self) {
        
        [self initMumber];
        [self initSubview];
        [self addData];
    }
    return self;
}

- (void)addData{
    
    [self.dataArray removeAllObjects];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSDate new] forKey:kNewsStartTime];
    [dict setObject:[NSDate new] forKey:kNewsEndTime];
    
    [dict setObject:@"Not only does Auto Layout" forKey:kNewsContent];
    [dict setObject:@"232af" forKey:kNewsId];
    
    DCNewsModel *model = [[DCNewsModel alloc] init];
    model.dict = dict;
    [self.dataArray addObject:model];
    
    NSDate *nown = [NSDate new];
    
    for (int i = 0; i < 10; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        nown = [NSDate dateWithTimeInterval:86400 sinceDate:nown];
        
        [dict setObject:nown forKey:kNewsStartTime];
        [dict setObject:nown forKey:kNewsEndTime];
        
        [dict setObject:@"Not only does Auto Layout makes it easy to support different screen sizes in your apps, as a bonus it also makes internationalization almost trivial. You no longer have to make new nibs or storyboards for every language that you wish to support" forKey:kNewsContent];
        [dict setObject:[NSString stringWithFormat:@"id___%d",i] forKey:kNewsId];
        
        DCNewsModel *model = [[DCNewsModel alloc] init];
        model.dict = dict;
        [self.dataArray addObject:model];
    }
    
    
    [self.newsTableview reloadData];
}


- (void)initMumber{
    self.dataArray = [NSMutableArray array];
}

- (void)initSubview{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"navigationbar"];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    UIImage *imageHight = [UIImage imageNamed:@"navigationbar_Hight"];
    [btn setBackgroundImage:imageHight forState:UIControlStateHighlighted];
    btn.bounds = (CGRect){CGPointZero,image.size};
    self.leftButton = btn;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"ADD" style:UIBarButtonItemStylePlain target:self action:@selector(addnews)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
    UITableView *table = [[UITableView alloc] init];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSelectionStyleNone;
    table.clipsToBounds = NO;
    
    __unsafe_unretained DCHomeViewController *blockSelf = self;
    [table setPullToRefreshHandler:^{
        [blockSelf pullToRefresh];
    }];
    [table setPullToRefreshViewActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [table setPullToRefreshViewPullingText:@"pull loading..."];
    [table setPullToRefreshViewReleaseText:@"let go load..."];
    [table setPullToRefreshViewLoadingText:@"loading..."];
    [table setPullToRefreshViewLoadedText:@""];
    
    [self.view addSubview:table];
    self.newsTableview = table;
    
    
 
    CGSize size  = [UIScreen mainScreen ].bounds.size;
    DCNewsAction *actionview = [[DCNewsAction alloc]init] ;
    actionview.frame = CGRectMake( 0 ,0 , size.width, size.height);
    self.newsActionView = actionview;
    
}


- (void)pullToRefresh{
    __block DCHomeViewController *blockself =self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [blockself addData];
    [blockself.newsTableview refreshFinished];
    });
    
}


- (void)addnews{
    
    DCADDNewsViewController *addnewsControll = [[DCADDNewsViewController alloc] init];
    
    [self.navigationController pushViewController:addnewsControll animated:YES];
    
}


#pragma mark - table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DCNewsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    return model.height +10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"DCHomeCell";
    DCNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[DCNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    
    cell.model = self.dataArray[indexPath.row];
    return cell;
}



#pragma mark - setupSubviewFrame

- (void)setupSubviewFrame{
    
    self.newsTableview.frame = self.view.bounds;
    
}



#pragma mark - setupNotification

- (void)setupNotification{
    NSNotificationCenter *cent = [NSNotificationCenter defaultCenter];
    
    [cent addObserver:self selector:@selector(newsAction:) name:@"newstapAction" object:nil];
}



#pragma mark - news Actions


- (void)newsAction:(NSNotification *)n{
    
    self.selectModel = [[n object] objectForKey:kNewsActionModel];
    [self.navigationController.view addSubview:self.newsActionView];
    __block DCHomeViewController *blockself =self;
    [self.newsActionView beginWithCompletion:^(DCNewsActionType newsAction) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [blockself.newsActionView removeFromSuperview];
            [blockself newsActionForType:newsAction];
            
        });
    }];
    
}

- (void)newsActionForType:(DCNewsActionType )type{
    switch (type) {
        case DCNewsActionDelete:{
            [self.dataArray removeObject:self.selectModel];
            [self.newsTableview reloadData];
            self.selectModel = nil;
        }
            break;
        case DCNewsActionUpdate:{
            DCADDNewsViewController *alternews = [[DCADDNewsViewController alloc] init];
            alternews.contentText.text = self.selectModel.content;
            [self.navigationController pushViewController:alternews animated:YES];
            self.selectModel = nil;
        }
            break;
        case DCNewsActionCancel:
            break;
            
        default:
            break;
    }
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
     [super touchesBegan:touches withEvent:event];
}

#pragma mark - self method


- (void)viewDidLoad {
    
    [super viewDidLoad];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"My News";
    [self setupNotification];
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
