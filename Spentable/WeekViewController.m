//
//  WeekViewController.m
//  Spentable
//
//  Created by Harris Dong on 2015/1/15.
//  Copyright (c) 2015年 Harris Dong. All rights reserved.
//

#import "WeekViewController.h"
#import "FormatHelper.h"
#import "DateHelper.h"
#import "DBManager.h"

static NSString *kRecordTableViewCell = @"RecordTableViewCell";


@interface WeekViewController ()

@property(weak, nonatomic) IBOutlet BEMSimpleLineGraphView *weekChooserView;
@property(weak, nonatomic) IBOutlet UITableView *recordTableView;
@property(strong, nonatomic) RLMResults *weekRecords;
@property(strong, nonatomic) NSArray *recordsArray;
@property(strong, nonatomic) NSDate *currentDate;

@end

@implementation WeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.weekChooserView.enableReferenceXAxisLines = YES;
    self.weekChooserView.enableXAxisLabel = YES;
//    self.weekChooserView.enableReferenceYAxisLines = YES;
//    self.weekChooserView.enableYAxisLabel = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return 7; // Number of points in the graph.
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    if (self.recordsArray.count && index < self.recordsArray.count) {
        RLMResults *dayResult = (RLMResults *)[self.recordsArray objectAtIndex:index];
        if (dayResult.count) {
            NSInteger sum = 0;
            for (HDTableRecord *record in dayResult) {
                sum += record.cost;
            }
            return sum;
        }
    }
    return 0; // The value of the point on the Y-Axis for the index.
}

- (NSInteger)numberOfXAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 7;
}


- (NSInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 7;
}


- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 0;
}



- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
//    return [NSString stringWithFormat:@"%ld", [DBManager instance]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    
    NSDate* date = [DateHelper firstOfWeek:self.currentDate andAddDays:index];
    NSString* str = [dateFormatter stringFromDate:date];
    return str;
}


//- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph {
//    return @"miles";
//}
//
//- (BOOL)lineGraph:(BEMSimpleLineGraphView *)graph alwaysDisplayPopUpAtIndex:(CGFloat)index {
//    if (index == 0 || index == 10) return YES;
//    else return NO;
//}

- (NSInteger)getIndexInWeek {
    
    NSTimeInterval interval = [self.currentDate timeIntervalSinceDate:[DateHelper firstOfWeek:self.currentDate]];
    
    return interval / 86400;
}

#pragma mark - inherit from BaseViewController

- (void)shouldUpdateRecord:(RLMResults *)recordList {
    if (recordList.count) {
        self.weekRecords = recordList;
        self.currentDate = [NSDate date];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];

        for (int i= 0; i < 7; i++) {
            
            NSPredicate *pred = [DateHelper getTodayPredicate:[DateHelper firstOfWeek:self.currentDate andAddDays:i]];
            RLMResults *dayRecord = [recordList objectsWithPredicate:pred];
            [array addObject:[[DBManager instance] getSumOfRecords:dayRecord]];
        }
        
        self.recordsArray = [NSArray arrayWithArray:array];
        
        [self.recordTableView reloadData];
        [self.weekChooserView reloadGraph];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    RLMResults* result = self.recordsArray[[self getIndexInWeek]];
    return result.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecordTableViewCell forIndexPath:indexPath];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:kRecordTableViewCell];
//    }
    RLMResults* result = self.recordsArray[[self getIndexInWeek]];
//
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    UILabel *categoryLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *costLabel = (UILabel *)[cell viewWithTag:102];
    UILabel *countOfResultsLabel = (UILabel *)[cell viewWithTag:103];
    
    HDTableRecord *record = (HDTableRecord *)[result objectAtIndex:indexPath.row];
    categoryLabel.text = record.category.categoryKeyOrName;
    costLabel.text = [FormatHelper costWithFormat:record.cost];
    countOfResultsLabel.text = [FormatHelper countOfRecordsWithFormat:record.countOfRecord];
//    cell.detailTextLabel.text = record.category.categoryKeyOrName;
//
//    cell.textLabel.text = [FormatHelper costWithFormat:record.cost];
    
    
    return cell;
}


@end
