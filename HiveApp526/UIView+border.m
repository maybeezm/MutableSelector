//
//  UIView+border.m
//  HiveApp526
//
//  Created by maybee on 2018/4/20.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import "UIView+border.h"
#import <Foundation/Foundation.h>
@implementation UIView (border)
- (void)addLine:(CGRect)frame color:(UIColor *)color{
    CALayer * bottomLayer = [CALayer layer];
    bottomLayer.backgroundColor = color.CGColor;
    bottomLayer.frame = frame;
    [self.layer addSublayer:bottomLayer];
}
- (void)addBorderTop:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width {
    if (top) {
        UIView *layer = [[UIView alloc] init];
        layer.frame = CGRectMake(0, 0, self.frame.size.width, width);
        layer.backgroundColor = color;
        [self addSubview:layer];
    }
    if (left) {
        UIView *layer = [[UIView alloc] init];
        layer.frame = CGRectMake(0, 0, width, self.frame.size.height);
        layer.backgroundColor = color;
        [self addSubview:layer];
    }
    if (bottom) {
        UIView *layer = [[UIView alloc] init];
        layer.frame = CGRectMake(0, self.frame.size.height - width, self.frame.size.width, width);
        layer.backgroundColor = color;
        [self addSubview:layer];
    }
    if (right) {
        UIView *layer = [[UIView alloc] init];
        layer.frame = CGRectMake(self.frame.size.width - width, 0, width, self.frame.size.height);
        layer.backgroundColor = color;
        [self addSubview:layer];
    }
}
@end
