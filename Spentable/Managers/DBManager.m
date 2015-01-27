//
//  DBManager.m
//  Spentable
//
//  Created by Harris Dong on 2015/1/24.
//  Copyright (c) 2015年 Harris Dong. All rights reserved.
//

#import "DBManager.h"
#import "CategoryManager.h"
#import "HDCategory.h"
#import "HDTableRecord.h"
#import "DateHelper.h"
#import <Realm.h>

static DBManager *_instance = nil;

@interface DBManager ()

@property(strong, nonatomic) RLMRealm *realm;
@property(strong, nonatomic) RLMResults *recordsArray;
@property(strong, nonatomic) RLMArray *sumOfWeekArray;
@property(strong, nonatomic) RLMArray *sumOfMonthArray;

@end

@implementation DBManager

+ (DBManager *)instance {
    if (_instance == nil) {
        _instance = [[DBManager alloc] init];
    }
    return _instance;
}

- (id)init {
    
    self = [super self];
    if (self) {
        self.realm = [RLMRealm defaultRealm];
    }
    return self;
}

- (void)insertRecord:(HDTableRecord *)record {
    
    [self.realm beginWriteTransaction];
    [self.realm addObject:record];
    [self.realm commitWriteTransaction];

}

- (void)insertOrUpdateCategories:(id)categories {
    
    [self.realm beginWriteTransaction];
    [self.realm addOrUpdateObjectsFromArray:categories];
    [self.realm commitWriteTransaction];
}

- (void)getWholeMonthRecords:(NSDate *)date  {
    
    self.recordsArray = [HDTableRecord objectsWithPredicate:[DateHelper getThisMonthPredicate:date]];
    self.recordsArray = [self.recordsArray sortedResultsUsingProperty:@"date" ascending:NO];
}

- (RLMResults *)getRecordsOfDay:(NSDate *)date {
    
    if (!self.recordsArray) {
        [self getWholeMonthRecords:date];
    }
    
    for (HDTableRecord *record in self.recordsArray) {
        NSLog(@"%@", record.uid);
        NSLog(@"%f", record.cost);
    }
    
    return [self.recordsArray objectsWithPredicate:[DateHelper getTodayPredicate:date]];
}

- (RLMResults *)getRecordsOfWeek:(NSDate *)date {
    
    if (!self.recordsArray) {
        [self getWholeMonthRecords:date];
    }
    return [self.recordsArray objectsWithPredicate:[DateHelper getThisWeekPredicate:date]];
}

- (RLMResults *)getRecordsOfMonth:(NSDate *)date {
    if (!self.recordsArray) {
        [self getWholeMonthRecords:date];
    }
    return self.recordsArray;
}

#pragma mark - Get sum of records

- (NSArray *)getSumOfRecords:(RLMResults *)recordList {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (HDCategory *category in [[CategoryManager instance] categoriesArray]) {
        RLMResults *result = [recordList objectsWhere:@"category.uid = %@", category.uid];
        NSNumber *sum = [result sumOfProperty:@"cost"];
        if (result.count) {
            HDTableRecord *record = [[HDTableRecord alloc] init];
            record.category = category;
            record.cost = [sum doubleValue];
            record.date = [(HDTableRecord *)[result firstObject] date];
            record.countOfRecord = result.count;
        
            [array addObject:record];
        }
    }
    return [NSArray arrayWithArray:array];

}




@end
