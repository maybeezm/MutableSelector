//
//  UIView+border.h
//  HiveApp526
//
//  Created by maybee on 2018/4/20.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (border)
- (void)addLine:(CGRect)frame color:(UIColor *)color;
- (void)addBorderTop:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;
@end
