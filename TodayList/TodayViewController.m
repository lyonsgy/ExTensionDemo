//
//  TodayViewController.m
//  TodayList
//
//  Created by lyons on 2019/2/27.
//  Copyright © 2019 lyons. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "GYTodo.h"
#import "GYFMDB.h"

@interface TodayViewController () <NCWidgetProviding, UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) NSMutableArray *dataArray;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(320, 300);
    
    self.dataArray = [NSMutableArray new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self checkTableArr];
}

//查询
- (void)checkTableArr{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[GYFMDBMANAGERG(@"GYTodo") fl_searchModelArr:[GYTodo class]]];
    [self.tableView reloadData];
    self.button.hidden = (self.dataArray.count>0);
    self.tableView.hidden = !(self.dataArray.count>0);
    if ([[UIDevice currentDevice] systemVersion].intValue >= 10) {
        if (self.dataArray.count>0) {
            self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
        }else{
            self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeCompact;
        }
    }
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSLog(@"%ld",(long)indexPath.row);
}
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = CGSizeMake(maxSize.width, 110);
    }else{
        self.preferredContentSize = CGSizeMake(maxSize.width, 300);
    }
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (IBAction)buttonClick:(UIButton *)sender {
    [self.extensionContext openURL:[NSURL URLWithString:@"todolist://new_todo"] completionHandler:^(BOOL success) {
        
    }];
}

@end
