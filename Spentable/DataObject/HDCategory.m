//
//  HDCategory.m
//  Spentable
//
//  Created by Harris Dong on 2015/1/23.
//  Copyright (c) 2015年 Harris Dong. All rights reserved.
//

#import "HDCategory.h"

@implementation HDCategory

+ (NSArray *)ignoredProperties {
    return @[@"image"];
}

+ (NSDictionary *)defaultPropertyValues {
    return @{@"imagePath": @"", @"isDefault": @NO};
}

+ (NSString *)primaryKey {
    return @"uid";
}

- (id)init {
    
    self = [super init];
    if (self)
        self.uid = [[NSUUID UUID] UUIDString];
    return self;
}


- (void)dealloc {
    NSLog(@"Make sure");
}



@end
