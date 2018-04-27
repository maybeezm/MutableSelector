//
//  UIViewController+Selector.h
//  HiveApp526
//
//  Created by maybee on 2018/4/20.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Selector)<CAAnimationDelegate>

//@property (nonatomic, readonly, strong) UIView *animationView;
@property (nonatomic, readonly, strong) NSMutableArray<UIView *> *animationViewArray;
- (void)chooseSelector:(UIView *)selector;
- (void)removeSelector:(UIView *)selector completeFunction:(SEL)sel;

@end
