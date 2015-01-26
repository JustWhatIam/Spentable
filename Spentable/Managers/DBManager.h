//
//  DBManager.h
//  Spentable
//
//  Created by Harris Dong on 2015/1/24.
//  Copyright (c) 2015年 Harris Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDTableRecord.h"

@interface DBManager : NSObject

+ (DBManager *)instance;

- (void)insertOrUpdateCategories:(id)categories;

- (void)insertRecord:(HDTableRecord *)record;

- (RLMResults *)getRecordsOfDay:(NSDate *)date;

- (RLMResults *)getRecordsOfWeek:(NSDate *)date;

- (RLMResults *)getRecordsOfMonth:(NSDate *)date;

- (NSArray *)getSumOfRecords:(RLMResults *)date;

- (NSPredicate *)getTodayPredicate:(NSDate *)date;

- (NSPredicate *)getTodayPredicate:(NSDate *)date andAddDays:(NSInteger)days;

- (NSPredicate *)getThisWeekPredicate:(NSDate *)date;

- (NSPredicate *)getThisMonthPredicate:(NSDate *)date;

@end
