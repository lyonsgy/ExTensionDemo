//
//  TableViewController.m
//  ExTensionDemo
//
//  Created by lyons on 2019/2/25.
//  Copyright © 2019 lyons. All rights reserved.
//

#import "TableViewController.h"
#import "FMDB.h"
#import "GYTodo.h"
#import "GYFMDB.h"

@interface TableViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createAddBtn];
    self.dataArray = [NSMutableArray new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self checkTableArr];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTodo:) name:kNEW_TODO_NOTIFICATION object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
//查询
- (void)checkTableArr{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[GYFMDBMANAGERG(@"GYTodo") fl_searchModelArr:[GYTodo class]]];
    [self.tableView reloadData];
}

//增加
- (BOOL)addData:(GYTodo*)todo{
    if ([GYFMDBMANAGERG(@"GYTodo") fl_insertModel:todo]) {
        return true;
    }
    return false;
}

- (void)createAddBtn{
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancleButton setTitle:@"添加" forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(addTodo:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancleButton];
    rightItem.imageInsets = UIEdgeInsetsMake(0, -15,0, 0);//设置向左偏移
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)addTodo:(id)sender{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNEW_TODO_NOTIFICATION object:nil];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"添加Todo"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    __weak __typeof(self)weakSelf = self;
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"保存"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              UITextField *todoTextField = alert.textFields.firstObject;
                                                              NSLog(@"%@",todoTextField.text);
                                                              //TODO:数据本地化
                                                              GYTodo *todo = [GYTodo new];
                                                              todo.content = todoTextField.text;
                                                              if ([weakSelf addData:todo]){
                                                                  [weakSelf checkTableArr];
                                                              }
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {}];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"todo";
    }];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    GYTodo *todo = _dataArray[indexPath.row];
    cell.textLabel.text = todo.content;
    return cell;
}

@end
