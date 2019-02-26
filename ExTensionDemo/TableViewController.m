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
    
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"GYTodo.sqlite"];
    //2.获得数据库
    self.db = [FMDatabase databaseWithPath:fileName];
    //3.使用如下语句，如果打开失败，可能是权限不足或者资源不足。通常打开完操作操作后，需要调用 close 方法来关闭数据库。在和数据库交互 之前，数据库必须是打开的。如果资源或权限不足无法打开或创建数据库，都会导致打开失败。
    if ([_db open])
    {
        //4.创表
        BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS GYTodo (id integer PRIMARY KEY AUTOINCREMENT, content text NOT NULL);"];
        if (result)
        {
            NSLog(@"创建表成功");
        }
    }
    [self checkTable];
}

//查询
- (void)checkTable{
//    //查询整个表
//    FMResultSet *resultSet = [self.db executeQuery:@"select * from GYTodo;"];
//    [self.dataArray removeAllObjects];
//    //遍历结果集合
//    while ([resultSet next])
//    {
//        int idNum = [resultSet intForColumn:@"id"];
//        NSString *content = [resultSet objectForColumn:@"content"];
//        GYTodo *todo = [GYTodo new];
//        todo.id = idNum;
//        todo.content = content;
//        [self.dataArray addObject:todo];
//        [self.tableView reloadData];
//    }
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[GYFMDBMANAGERX(@"GYTodo") fl_searchModelArr:[GYTodo class]]];
    [self.tableView reloadData];
}

//增加
- (BOOL)addData:(GYTodo*)todo{
    //1.executeUpdate:不确定的参数用？来占位（后面参数必须是oc对象，；代表语句结束）
    if ([_db executeUpdate:@"INSERT INTO GYTodo (content) VALUES (?);",todo.content]) {
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
                                                                  [weakSelf checkTable];
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
