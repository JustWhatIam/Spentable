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
    
    self.recordsArray = [HDTableRecord objectsWithPredicate:[self getThisMonthPredicate:date]];
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
    
    return [self.recordsArray objectsWithPredicate:[self getTodayPredicate:date]];
}

- (RLMResults *)getRecordsOfWeek:(NSDate *)date {
    
    if (!self.recordsArray) {
        [self getWholeMonthRecords:date];
    }
    return [self.recordsArray objectsWithPredicate:[self getThisWeekPredicate:date]];
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
        
            [array addObject:record];
        }
    }
    return [NSArray arrayWithArray:array];

}

#pragma mark - Get NSPredicate for specific range

- (NSPredicate *)getTodayPredicate:(NSDate *)date {
    
        return [self getTodayPredicate:date andAddDays:0];
}

- (NSPredicate *)getTodayPredicate:(NSDate *)date andAddDays:(NSInteger)days {
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [comp setDay:comp.day+days];
    NSDate *today = [cal dateFromComponents:comp];
    [comp setDay:comp.day+1];
    NSDate *tomorrow = [cal dateFromComponents:comp];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", today, tomorrow];
    
    return  pred;
}

- (NSPredicate *)getThisWeekPredicate:(NSDate *)date {
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekOfMonthCalendarUnit) fromDate:date];
    
    [comp setWeekday:1]; //Sunday
    NSDate *firstDayOfThisMonth = [cal dateFromComponents:comp];
    
    NSDateComponents *oneWeek = [[NSDateComponents alloc] init];
    [oneWeek setDay:8];
    NSDate *firstDayOfNextMonth = [cal dateByAddingComponents:oneWeek toDate:firstDayOfThisMonth options:0];
    
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", firstDayOfThisMonth, firstDayOfNextMonth];
    
    return pred;
}

- (NSPredicate *)getThisMonthPredicate:(NSDate *)date {
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfThisMonth = [cal dateFromComponents:comp];
    [comp setMonth:comp.month+1];
    NSDate *firstDayOfNextMonth = [cal dateFromComponents:comp];
    //[cal dateByAddingUnit:NSMonthCalendarUnit value:1 toDate:firstDayOfThisMonth options:0]; NS_AVAILABLE(10_9, 8_0)
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", firstDayOfThisMonth, firstDayOfNextMonth];
    
    return pred;
}



@end
