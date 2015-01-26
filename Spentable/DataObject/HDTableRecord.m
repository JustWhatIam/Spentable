//
//  HDTableRecord.m
//  Spentable
//
//  Created by Harris Dong on 2015/1/23.
//  Copyright (c) 2015年 Harris Dong. All rights reserved.
//

#import "HDTableRecord.h"

@implementation HDTableRecord

- (id)init {

    self = [super init];
    self.uid = [[NSUUID UUID] UUIDString];
    return self;
}

- (void)dealloc {
    NSLog(@"eee");
}

+ (NSString *)primaryKey {
    return @"uid";
}

@end
