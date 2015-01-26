//
//  CategoryManager.m
//  Spentable
//
//  Created by Harris Dong on 2015/1/23.
//  Copyright (c) 2015年 Harris Dong. All rights reserved.
//

#import "CategoryManager.h"
#import "HDCategory.h"
#import "DBManager.h"

static CategoryManager *_instance = nil;

NSString * const _settingsPlistPath = @"Settings.plist";
NSString * const _keyForCategory = @"Category";

@interface CategoryManager ()

@end

@implementation CategoryManager



+ (CategoryManager *)instance {
    if (_instance == nil) {
        _instance = [[CategoryManager alloc] init];
    }
    return _instance;
}

- (id)init {

    self = [super self];
    if (self) {
        [self setupCategoryArray];
    }
    return self;
}

- (void)setupCategoryArray {
    
    self.categoriesArray = [HDCategory allObjects];
    if (!self.categoriesArray.count) {
        NSArray *categoriesInPlist = [self getCategoriesInSettingsPlist];
        [[DBManager instance] insertOrUpdateCategories:categoriesInPlist];
        self.categoriesArray = [HDCategory allObjects];
    }
    else {
        //Update default categories changed
//        BOOL isImagePathModified = NO;
//        for (HDCategory *category in categoriesInPlist) {
//            RLMResults *result = [self.categoriesArray objectsWhere:@"categoryKeyOrName = %@ AND isDefault == %@", category.categoryKeyOrName, NO];
//            HDCategory * resultObj = [result firstObject];
//            if (![resultObj.imagePath isEqualToString:category.categoryKeyOrName]) {
//                resultObj.imagePath = category.categoryKeyOrName;
//                isImagePathModified = YES;
//            }
//        }
//        if (isImagePathModified)
//            [[DBManager instance] insertOrUpdateCategories:self.categoriesArray];
    }
}

- (NSArray *)getCategoriesInSettingsPlist {
    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:_settingsPlistPath];
    NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray *categories;
    NSMutableArray *array;
    if (plistDict) {
        categories = [plistDict objectForKey:_keyForCategory];
        array = [[NSMutableArray alloc] init];
        
        for (NSString *str in categories) {
            NSArray *splitArr = [str componentsSeparatedByString:@"|"];
            
            HDCategory *obj = [[HDCategory alloc] init];
            if (splitArr.count == 2) {
                obj.categoryKeyOrName = [splitArr objectAtIndex:0];
                obj.imagePath = [splitArr objectAtIndex:1];
                [array addObject:obj];
            }
        }
        
    }
    return [NSArray arrayWithArray:array];
}


@end
