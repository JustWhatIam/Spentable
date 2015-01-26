//
//  DayViewController.m
//  Spentable
//
//  Created by Harris Dong on 2015/1/15.
//  Copyright (c) 2015年 Harris Dong. All rights reserved.
//

#import "DayViewController.h"

static NSString *kCellIdentifier = @"DateCollectionViewCell";
static NSString *kRecordTableViewCell = @"RecordTableViewCell";


@interface DayViewController ()

@property(weak, nonatomic) IBOutlet UILabel *header;
@property(weak, nonatomic) IBOutlet UICollectionView *dateCollectionView;
@property(weak, nonatomic) IBOutlet UITableView *recordTableView;

@property(strong, nonatomic) NSDate *currentDate;
@property(assign, nonatomic) NSRange monthRange;
@property(strong, nonatomic) NSArray *daysArray;
@property(strong, nonatomic) RLMResults *recordsArray;



@end

@implementation DayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupCurrentDate];
    
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

- (void)shouldUpdateRecord:(RLMResults *)recordList {
    if (recordList.count) {
        self.recordsArray = recordList;
        [self.recordTableView reloadData];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger width = self.view.frame.size.width;
    width /= 7;
    
    return CGSizeMake(width, width);
}

//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    return CGSizeMake(320, 45);
//}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecordTableViewCell forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    UILabel *categoryLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *costLabel = (UILabel *)[cell viewWithTag:102];
    HDTableRecord *record = (HDTableRecord *)[self.recordsArray objectAtIndex:indexPath.row];
    
    categoryLabel.text = record.category.categoryKeyOrName;
    costLabel.text = [NSString stringWithFormat:@"$%f", record.cost];
    
    
    return cell;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.monthRange.length+2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    NSNumber *day = [self.daysArray objectAtIndex:indexPath.row];
    
    label.text = [day stringValue];
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // Calculate where the collection view should be at the right-hand end item
    float contentOffsetWhenFullyScrolledRight = self.dateCollectionView.frame.size.width * ([self.daysArray count] -1);
    
    if (scrollView.contentOffset.x == contentOffsetWhenFullyScrolledRight) {
        
        // user is scrolling to the right from the last item to the 'fake' item 1.
        // reposition offset to show the 'real' item 1 at the left-hand end of the collection view
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        
        [self.dateCollectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        
    } else if (scrollView.contentOffset.x == 0)  {
        
        // user is scrolling to the left from the first item to the fake 'item N'.
        // reposition offset to show the 'real' item N at the right end end of the collection view
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:([self.daysArray count] -2) inSection:0];
        
        [self.dateCollectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        
    }
    
}

#pragma mark - DateTime

- (void)setupCurrentDate {
    self.currentDate = [NSDate date];
    self.header.text = [self getMonthName];
    
    //days in month
    NSCalendar *c = [NSCalendar currentCalendar];
    self.monthRange = [c rangeOfUnit:NSDayCalendarUnit
                           inUnit:NSMonthCalendarUnit
                          forDate:self.currentDate];
    
    
    NSMutableArray *workingArray = [[NSMutableArray alloc] init];
    for (NSUInteger i = 1; i <= self.monthRange.length; i++) {
        [workingArray addObject:[NSNumber numberWithInteger:i]];
    }
    
    id firstDay = workingArray[0];
    id lastDay = [workingArray lastObject];
    [workingArray insertObject:lastDay atIndex:0];
    [workingArray addObject:firstDay];
    
    
    self.daysArray = [NSArray arrayWithArray:workingArray];
}

- (NSString *)getMonthName {
//    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.currentDate];
    //    NSInteger day = [components day];
    //    NSInteger month = [components month];
    //    NSInteger year = [components year];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM, y"];
    NSString *month = [dateFormatter stringFromDate:self.currentDate];
    
//    NSLog(@"%@", month);
    return month;
}

@end
