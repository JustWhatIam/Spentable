//
//  DateHelper.m
//  Spentable
//
//  Created by Harris Dong on 2015/1/27.
//  Copyright (c) 2015年 Harris Dong. All rights reserved.
//

#import "DateHelper.h"
static NSCalendar *_calendar = nil;

@interface DateHelper ()

@property NSString *s;

@end

@implementation DateHelper

+ (NSCalendar *)getCalendar {
    if (!_calendar) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
    return _calendar;
}

+ (NSDate *)today:(NSDate *)date andAddDays:(NSInteger)days {
    NSCalendar *cal = [self getCalendar];
    NSDateComponents *comp = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
    [comp setDay:comp.day+days];
    return [cal dateFromComponents:comp];
}


+ (NSDate *)firstOfWeek:(NSDate *)date {
    NSCalendar *cal = [self getCalendar];
    NSDateComponents *comp = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekOfMonthCalendarUnit) fromDate:date];
    
    [comp setWeekday:1]; //Sunday
    return [cal dateFromComponents:comp];
}

+ (NSDate *)firstOfWeek:(NSDate *)date andAddDays:(NSInteger)days {
    NSCalendar *cal = [self getCalendar];

    NSDate *firstDayOfThisMonth = [DateHelper firstOfWeek:date];
    
    NSDateComponents *addDaysComp = [[NSDateComponents alloc] init];
    [addDaysComp setDay:days];
    return [cal dateByAddingComponents:addDaysComp toDate:firstDayOfThisMonth options:0];
}

+ (NSDate *)firstOfMonth:(NSDate *)date {
    NSCalendar *cal = [self getCalendar];
    NSDateComponents *comp = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [comp setDay:1];
    
    return [cal dateFromComponents:comp];
}

+ (NSDate *)firstOfMonth:(NSDate *)date andAddMonth:(NSInteger)months {
    NSCalendar *cal = [self getCalendar];
    NSDateComponents *comp = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [comp setDay:1];
    [comp setMonth:comp.month+months];
    
    return [cal dateFromComponents:comp];
    //[cal dateByAddingUnit:NSMonthCalendarUnit value:1 toDate:firstDayOfThisMonth options:0]; NS_AVAILABLE(10_9, 8_0)
}

#pragma mark - Get NSPredicate for specific range

+ (NSPredicate *)getTodayPredicate:(NSDate *)date {

    return [self getTodayPredicate:date andAddDays:0];
}

+ (NSPredicate *)getTodayPredicate:(NSDate *)date andAddDays:(NSInteger)days {
    
    
    NSDate *today = [self today:date andAddDays:0];
    
    NSDate *tomorrow = [self today:date andAddDays:1];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", today, tomorrow];
    
    return  pred;
}

+ (NSPredicate *)getThisWeekPredicate:(NSDate *)date {
    
    //Sunday
    NSDate *firstDayOfThisMonth = [self firstOfWeek:date];
    //Next Sunday
    NSDate *firstDayOfNextMonth = [self firstOfWeek:date andAddDays:8];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", firstDayOfThisMonth, firstDayOfNextMonth];
    
    return pred;
}

+ (NSPredicate *)getThisMonthPredicate:(NSDate *)date {
    
    //First of this month
    NSDate *firstDayOfThisMonth = [self firstOfMonth:date];
    //First of next month
    NSDate *firstDayOfNextMonth = [self firstOfMonth:date andAddMonth:1];
    //[cal dateByAddingUnit:NSMonthCalendarUnit value:1 toDate:firstDayOfThisMonth options:0]; NS_AVAILABLE(10_9, 8_0)
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", firstDayOfThisMonth, firstDayOfNextMonth];
    
    return pred;
}

@end
