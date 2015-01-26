//
//  FormatHelper.h
//  Spentable
//
//  Created by Harris Dong on 2015/1/26.
//  Copyright (c) 2015年 Harris Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormatHelper : NSObject

+ (NSString *)costWithFormat:(double)cost;

+ (NSString *)countOfRecordsWithFormat:(NSInteger)count;

@end
