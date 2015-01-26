//
//  DateCollectionViewCell.m
//  Spentable
//
//  Created by Harris Dong on 2015/1/21.
//  Copyright (c) 2015年 Harris Dong. All rights reserved.
//

#import "DateCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation DateCollectionViewCell

- (void)awakeFromNib {

    
}

- (void)drawRect:(CGRect)rect {

    double newSize = self.frame.size.width;

    CGPoint saveCenter = self.center;
    CGRect newFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newSize, newSize);
    self.frame = newFrame;
    self.layer.cornerRadius = newSize / 2.0;
    //    self.layer.masksToBounds = YES;
    self.center = saveCenter;
    
    
    // Another way to draw circle
//    // inset by half line width to avoid cropping where line touches frame edges
//    CGRect insetRect = CGRectInset(rect, 0.5, 0.5);
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:insetRect cornerRadius:rect.size.height/2.0];
//    
//    // white background
//    [[UIColor whiteColor] setFill];
//    [path fill];
//    
//    // red outline
//    [[UIColor redColor] setStroke];
//    [path stroke];
}

@end
