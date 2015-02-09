//
//  drawLineView.m
//  TicTacToe
//
//  Created by XiaoYifan on 2/9/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import "drawLineView.h"

@implementation drawLineView


-(void)drawRect:(CGRect)rect{

   NSLog(@"draw a line between point1: (%f, %f), point2: (%f, %f)", self.point1.x, self.point1.y,self.point2.x, self.point2.y);
    
   CGContextRef context = UIGraphicsGetCurrentContext();
   CGContextSetLineWidth(context, 2.0);
   CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
   CGFloat components[] = {0.0, 0.0, 1.0, 1.0};
   CGColorRef color = CGColorCreate(colorspace, components);
   CGContextSetStrokeColorWithColor(context, color);
   CGContextMoveToPoint(context, self.point1.x, self.point1.y);
   CGContextAddLineToPoint(context, self.point2.x, self.point2.y);
   CGContextStrokePath(context);
   CGColorSpaceRelease(colorspace);
   CGColorRelease(color);
    
}


@end
