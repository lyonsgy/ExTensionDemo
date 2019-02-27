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
    if ([[UIDevice currentDevice] systemVersion].intValue >= 10) {
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    }
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

@end
