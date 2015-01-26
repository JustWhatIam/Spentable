//
//  FormatHelper.m
//  Spentable
//
//  Created by Harris Dong on 2015/1/26.
//  Copyright (c) 2015年 Harris Dong. All rights reserved.
//

#import "FormatHelper.h"

@implementation FormatHelper

+ (NSString *)costWithFormat:(double)cost {
    return [NSString stringWithFormat:@"$%.2f", cost];
}

+ (NSString *)countOfRecordsWithFormat:(NSInteger)count {
    if (count == 1)
        return [NSString stringWithFormat:@"%ld record", count];
    else if(count > 1)
        return [NSString stringWithFormat:@"%ld records", count];
    return nil;
}


@end
