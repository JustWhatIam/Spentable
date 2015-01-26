//
//  ViewController.m
//  Spentable
//
//  Created by Harris Dong on 2015/1/15.
//  Copyright (c) 2015年 Harris Dong. All rights reserved.
//

#import "MainViewController.h"
#import "KLCPopup.h"
#import "AddRecordViewController.h"
#import "DateTimeViewController.h"
#import "CategoryViewController.h"
#import "DBManager.h"
#import "DayViewController.h"
#import "WeekViewController.h"
#import "MonthViewController.h"
#import "CategoryManager.h"


@interface MainViewController ()

@property(weak, nonatomic) IBOutlet UISegmentedControl *categorySwitch;
@property(weak, nonatomic) IBOutlet UIView *contentView;
@property(strong, nonatomic) UIViewController *currentViewController;
@property(strong, nonatomic) AddRecordViewController *addRecordViewController;
@property(strong, nonatomic) DateTimeViewController *dateTimeViewController;
@property(strong, nonatomic) CategoryViewController *categoryViewController;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIViewController *vc = [self viewControllerForSegmentIndex:self.categorySwitch.selectedSegmentIndex];
    [self addChildViewController:vc];
    vc.view.frame = self.contentView.bounds;
    [self.contentView addSubview:vc.view];
    self.currentViewController = vc;

    [self updateRecord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateRecord {
    
    if ([self.currentViewController isKindOfClass:[DayViewController class]]) {
        [(BaseViewController *)self.currentViewController shouldUpdateRecord:[[DBManager instance] getRecordsOfDay:[NSDate date]]];
    }
    else if([self.currentViewController isKindOfClass:[WeekViewController class]]) {
        [(BaseViewController *)self.currentViewController shouldUpdateRecord:[[DBManager instance] getRecordsOfWeek:[NSDate date]]];
    }
    else if([self.currentViewController isKindOfClass:[MonthViewController class]]) {
        [(BaseViewController *)self.currentViewController shouldUpdateRecord:[[DBManager instance] getRecordsOfMonth:[NSDate date]]];

    }
    
}

#pragma mark - IBAction

- (IBAction)categorySwitchIndexChanged:(id)sender {
    UIViewController *vc = [self viewControllerForSegmentIndex:self.categorySwitch.selectedSegmentIndex];
    [self addChildViewController:vc];
    [self transitionFromViewController:self.currentViewController toViewController:vc duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom
        animations:^{
            [self.currentViewController.view removeFromSuperview];
            vc.view.frame = self.contentView.bounds;
            [self.contentView addSubview:vc.view];
        } completion:^(BOOL finished) {
            [vc didMoveToParentViewController:self];
            [self.currentViewController removeFromParentViewController];
            self.currentViewController = vc;
            
            [self updateRecord];
        }];
    
}

- (IBAction)addButtonClicked:(id)sender {
    
    self.addRecordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddRecordViewController"];
    self.addRecordViewController.delegate = self;
    
    
    KLCPopup *popup = [KLCPopup popupWithContentView:self.addRecordViewController.view];

    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom);
    
    popup.willStartDismissingCompletion = ^{
        [self updateRecord];
    };
    
    [popup showWithLayout:layout];
}

#pragma mark - Controller Switch

- (UIViewController *)viewControllerForSegmentIndex:(NSInteger)index {
    UIViewController *vc = nil;
    switch (index) {
        case 0:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DayViewController"];
            break;
        case 1:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WeekViewController"];
            break;
        case 2:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MonthViewController"];
            break;
    }
    return vc;
}

#pragma mark - Popup delegate

- (void)shouldDismiss:(AddRecordViewController *)newRecordViewController {
    
}


@end
