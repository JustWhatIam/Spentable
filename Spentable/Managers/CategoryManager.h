//
//  CategoryManager.h
//  Spentable
//
//  Created by Harris Dong on 2015/1/23.
//  Copyright (c) 2015年 Harris Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm.h>

@interface CategoryManager : NSObject

@property(strong, nonatomic) RLMResults *categoriesArray;

+ (CategoryManager *)instance;
@end
