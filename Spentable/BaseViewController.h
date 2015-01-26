//
//  BaseViewController.h
//  Spentable
//
//  Created by Harris Dong on 2015/1/16.
//  Copyright (c) 2015年 Harris Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDTableRecord.h"

//@protocol BaseViewControllerDelegate;

@interface BaseViewController : UIViewController

//@property (nonatomic, weak) id <BaseViewControllerDelegate> delegate;

- (void)shouldUpdateRecord:(RLMResults *)recordList;

@end


//@class  BaseViewController;
//
//@protocol BaseViewControllerDelegate <NSObject>
//
//@required
//
//- (void)shouldUpdateRecord:(NSArray *)recordList;
//
//@end


