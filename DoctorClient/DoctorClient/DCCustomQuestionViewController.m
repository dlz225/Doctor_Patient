//
//  DCCustomQuestionViewController.m
//  DoctorClient
//
//  Created by JiangTeng on 14/10/31.
//  Copyright (c) 2014年 com.usc. All rights reserved.
//

#import "DCCustomQuestionViewController.h"

@interface DCCustomQuestionViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *questionsArray;
@property (nonatomic, strong) UITableView *questionsTalbe;

@end

@implementation DCCustomQuestionViewController


- (id)init{
    self = [super init];
    if (self) {
        
        [self initMumber];
        [self initSubview];
    }
    
    return self;
}

- (void)initMumber{
    self.resultDict = [NSMutableDictionary dictionary];
    self.questionsArray = [NSMutableArray array];
}

- (void)initSubview{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"navigationbar_back"];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    btn.bounds = (CGRect){CGPointZero,image.size};
    [btn addTarget:self action:@selector(getBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UITableView *tableview = [[UITableView alloc] init];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.clipsToBounds = NO;
    [self.view addSubview:tableview];
    self.questionsTalbe = tableview;
    
    
    [self.view setupSubviewTag];
}



- (void)getBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark - table view delegate 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.questionsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *customIdentifier = @"DCCustom";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    CGRect newframe = cell.textLabel.frame;
    newframe.origin.x = 10;
    newframe.size.width -= 10;
    cell.textLabel.frame =newframe;
    cell.textLabel.text = self.questionsArray[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = kTextColor;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    return cell;
}





- (void)setupSubviewFrame{
    self.questionsTalbe.frame = self.view.bounds;
}



#pragma mark - self method

- (void)setResultDict:(NSMutableDictionary *)resultDict{
    _resultDict = resultDict;
    self.questionsArray = [resultDict objectForKey:kQuestionsArray];
    [self.questionsTalbe reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"Questions";

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
