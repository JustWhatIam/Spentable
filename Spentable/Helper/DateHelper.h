//
//  DateHelper.h
//  Spentable
//
//  Created by Harris Dong on 2015/1/27.
//  Copyright (c) 2015年 Harris Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

+ (NSDate *)today:(NSDate *)date andAddDays:(NSInteger)days;

+ (NSDate *)firstOfWeek:(NSDate *)date;

+ (NSDate *)firstOfWeek:(NSDate *)date andAddDays:(NSInteger)days;

+ (NSDate *)firstOfMonth:(NSDate *)date;

+ (NSDate *)firstOfMonth:(NSDate *)date andAddMonth:(NSInteger)months;

+ (NSPredicate *)getTodayPredicate:(NSDate *)date;

+ (NSPredicate *)getTodayPredicate:(NSDate *)date andAddDays:(NSInteger)days;

+ (NSPredicate *)getThisWeekPredicate:(NSDate *)date;

+ (NSPredicate *)getThisMonthPredicate:(NSDate *)date;


@end
