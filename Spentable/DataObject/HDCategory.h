//
//  HDCategory.h
//  Spentable
//
//  Created by Harris Dong on 2015/1/23.
//  Copyright (c) 2015年 Harris Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Realm.h>

@interface HDCategory : RLMObject

@property NSString *uid;
@property NSString *categoryKeyOrName;
@property NSString *imagePath;
@property BOOL isDefault;
@property (strong, nonatomic) UIImage *image;

@end
