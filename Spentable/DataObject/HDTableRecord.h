//
//  HDTableRecord.h
//  Spentable
//
//  Created by Harris Dong on 2015/1/23.
//  Copyright (c) 2015年 Harris Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDCategory.h"
#import <Realm.h>

@interface HDTableRecord : RLMObject

@property NSString *uid;
@property HDCategory *category;
@property NSDate *date;
@property double cost;

@end
