//
//  BoundaryView.m
//  GimbalControlObjC
//
//  Created by Simon Anthony on 19/02/2015.
//  Copyright (c) 2015 Autonomous Technologies. All rights reserved.
//

#import "BoundaryView.h"

@implementation BoundaryView

- (void)drawRect:(CGRect)rect {
    
    UIColor *boundaryBackgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.25];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGRect rectangle = CGRectMake(((super.center.x * 2) - 15) - super.center.x * 0.5, ((super.center.y * 2) - 105) - super.center.y * 0.4, super.center.x * 0.5, super.center.y * 0.4);
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);
    CGContextSetFillColorWithColor(context, boundaryBackgroundColor.CGColor);
    CGContextFillRect(context, rectangle);
}

@end