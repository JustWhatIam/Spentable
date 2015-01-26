//
//  NewRecordViewController.h
//  Spentable
//
//  Created by Harris Dong on 2015/1/17.
//  Copyright (c) 2015年 Harris Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewRecordViewControllerDelegate;

@interface AddRecordViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) id <NewRecordViewControllerDelegate> delegate;

@end



@protocol NewRecordViewControllerDelegate <NSObject>

@required

- (void)shouldDismiss:(AddRecordViewController *)newRecordViewController;

@end


