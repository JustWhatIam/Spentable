//
//  MonthViewController.m
//  Spentable
//
//  Created by Harris Dong on 2015/1/15.
//  Copyright (c) 2015年 Harris Dong. All rights reserved.
//

#import "MonthViewController.h"
#import "FormatHelper.h"
#import "DBManager.h"

static NSString *kRecordTableViewCell = @"RecordTableViewCell";

@interface MonthViewController ()

@property(weak, nonatomic) IBOutlet UITableView *recordTableView;
@property(strong, nonatomic) RLMResults *monthRecords;
@property(strong, nonatomic) NSArray *recordsArray;
@property(strong, nonatomic) NSDate *currentDate;

@end

@implementation MonthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

#pragma mark - inherit from BaseViewController

- (void)shouldUpdateRecord:(RLMResults *)recordList {
    if (recordList.count) {
        self.monthRecords = recordList;
        self.currentDate = [NSDate date];
        
        self.recordsArray = [[DBManager instance] getSumOfRecords:recordList];
        
        [self.recordTableView reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordsArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecordTableViewCell forIndexPath:indexPath];
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:kRecordTableViewCell];
    //    }
    //
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    UILabel *categoryLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *costLabel = (UILabel *)[cell viewWithTag:102];
    UILabel *countOfResultsLabel = (UILabel *)[cell viewWithTag:103];
    
    HDTableRecord *record = (HDTableRecord *)[self.recordsArray objectAtIndex:indexPath.row];
    categoryLabel.text = record.category.categoryKeyOrName;
    costLabel.text = [FormatHelper costWithFormat:record.cost];
    countOfResultsLabel.text = [FormatHelper countOfRecordsWithFormat:record.countOfRecord];
    //    cell.detailTextLabel.text = record.category.categoryKeyOrName;
    //
    //    cell.textLabel.text = [FormatHelper costWithFormat:record.cost];
    
    
    return cell;
}


@end
