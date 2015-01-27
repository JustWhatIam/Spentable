//
//  NewRecordViewController.m
//  Spentable
//
//  Created by Harris Dong on 2015/1/17.
//  Copyright (c) 2015年 Harris Dong. All rights reserved.
//

#import "AddRecordViewController.h"
#import "DateTimeViewController.h"
#import "CategoryViewController.h"
#import "CategoryManager.h"
#import "DBManager.h"
#import "HDCategory.h"
#import "KLCPopup.h"

const int digitLimit = 10;

static NSString *kCategoryIdentifier = @"CategoryViewCell";

@interface AddRecordViewController () {

}

@property(weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(weak, nonatomic) IBOutlet UILabel *costLabel;
@property(weak, nonatomic) IBOutlet UIButton *dateTimeButton;
@property(strong, nonatomic) NSString *costStr;
@property(strong, nonatomic) RLMResults *categories;
@property(strong, nonatomic) HDCategory *selectedCateory;
@property(strong, nonatomic) NSDate *currentDate;

@end

@implementation AddRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
//    self.view.layer.cornerRadius = 5;
//    self.view.layer.shadowOpacity = 0.8;
//    self.view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    _costStr = nil;
    [self updateNumpad];
    [self updateDateTimeButton];
    self.categories = [[CategoryManager instance] categoriesArray];
}

- (void)viewDidAppear:(BOOL)animated {
    int index = 0;
    NSIndexPath *selection = [NSIndexPath indexPathForItem:index
                                                 inSection:0];
    [self.collectionView selectItemAtIndexPath:selection
                                      animated:YES
                                scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:self.collectionView didHighlightItemAtIndexPath:selection];
    self.selectedCateory = self.categories[index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"dealloc");
}

#pragma mark - Setter, Getter

- (void)setCostStr:(NSString *)str {
    if (str.length > digitLimit) {
        return;
    }
    _costStr = str;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Category

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCategoryIdentifier forIndexPath:indexPath];

    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    id obj = self.categories[[indexPath row]];
    if ([obj isKindOfClass:[HDCategory class]]) {
        HDCategory *cate = (HDCategory *)obj;
        label.text = cate.categoryKeyOrName;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedCateory = self.categories[indexPath.row];
}


- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    //set color with animation
    for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        [UIView animateWithDuration:0.1
                              delay:0
                            options:(UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
                             [cell setBackgroundColor:[UIColor clearColor]];
                         }
                         completion:nil ];
    }

//    if (!cell.isSelected) {

        [UIView animateWithDuration:0.1
                              delay:0
                            options:(UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
                         [  cell setBackgroundColor:[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1]];
                         }
                         completion:nil];
//    }
}

- (void)updateDateTimeButton {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.currentDate = [NSDate date];
    [self.dateTimeButton setTitle:[dateFormatter stringFromDate:self.currentDate] forState:UIControlStateNormal];
}

#pragma mark - Numpad number handling

- (void)addNumber:(NSInteger)num {
    
    NSString *numStr;
    
    switch (num) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 0:
            numStr = [NSString stringWithFormat:@"%ld", (long)num];
            break;
        default:
            NSLog(@"Wrong number digit");
            return;
    }
    
    if([numStr isEqualToString:@"0"]) {
        if(self.costStr)
           self.costStr = [self.costStr stringByAppendingString:numStr];
    }
    else {
        if (self.costStr) {
            self.costStr = [self.costStr stringByAppendingString:numStr];
        }
        else {
            self.costStr = numStr;
        }
    }
    
    
    [self updateNumpad];
    
}

- (void)updateNumpad {
    
    if(self.costStr.length) {
        self.costLabel.text = [NSString stringWithFormat:@"$%@", self.costStr];
    }
    else {
        self.costLabel.text = @"$0";
    }

}

#pragma mark - Numpad IBAction

- (IBAction)saveButtonClieck:(id)sender {
    
    if(self.costStr) {
        double cost = [self.costStr doubleValue];
        if(cost) {
            NSLog(@"Cost $%f", cost);
            HDTableRecord *record = [[HDTableRecord alloc] init];
            
            record.category = self.selectedCateory;
            record.date = self.currentDate;
            record.cost = cost;
            
            [[DBManager instance] insertRecord:record];
            [self.view dismissPresentingPopup];
            
            if ([self.delegate respondsToSelector:@selector(shouldDismiss:)]) {
                [self.delegate shouldDismiss:self];
            }
        }
    }
}

- (IBAction)closeButtonClicked:(id)sender {
    [self.view dismissPresentingPopup];
}

- (IBAction)dateTimeButtonClicked:(id)sender {
    DateTimeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DateTimeViewController"];
    
    KLCPopup *popup = [KLCPopup popupWithContentView:vc.view];
    
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom);
    
    popup.willStartDismissingCompletion = ^{
        
    };
    
    [popup showWithLayout:layout];

}

- (IBAction)categorySettingButtonClicked:(id)sender {
    CategoryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryViewController"];
    
    KLCPopup *popup = [KLCPopup popupWithContentView:vc.view];
    
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom);
    
    popup.willStartDismissingCompletion = ^{
        
    };
    
    [popup showWithLayout:layout];
}

- (IBAction)numDotButtonClicked:(id)sender {
    if (self.costStr.length) {
        if ([self.costStr rangeOfString:@"."].location == NSNotFound) {
            self.costStr = [self.costStr stringByAppendingString:@"."];
            [self updateNumpad];
        }
    }
    else {
        self.costStr = @"0.";
        [self updateNumpad];
    }
}

- (IBAction)numBackButtonClicked:(id)sender {
    if (self.costStr.length) {
        self.costStr = [self.costStr substringToIndex:self.costStr.length-1];
        [self updateNumpad];
    }
}

- (IBAction)num9ButtonClicked:(id)sender {
    [self addNumber:9];
}

- (IBAction)num8ButtonClicked:(id)sender {
    [self addNumber:8];
}

- (IBAction)num7ButtonClicked:(id)sender {
    [self addNumber:7];
}

- (IBAction)num6ButtonClicked:(id)sender {
    [self addNumber:6];
}

- (IBAction)num5ButtonClicked:(id)sender {
    [self addNumber:5];
}

- (IBAction)num4ButtonClicked:(id)sender {
    [self addNumber:4];
}

- (IBAction)num3ButtonClicked:(id)sender {
    [self addNumber:3];
}

- (IBAction)num2ButtonClicked:(id)sender {
    [self addNumber:2];
}

- (IBAction)num1ButtonClicked:(id)sender {
    [self addNumber:1];
}

- (IBAction)num0ButtonClicked:(id)sender {
    [self addNumber:0];
}

@end
