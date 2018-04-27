//
//  UIViewController+Selector.m
//  HiveApp526
//
//  Created by maybee on 2018/4/20.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import "UIViewController+Selector.h"
#import <POP.h>
#import <objc/runtime.h>

#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)

@implementation UIViewController (Selector)
- (void)chooseSelector:(UIView *)selector{
    if (!self.animationViewArray) {
        self.animationViewArray = [[NSMutableArray alloc]init];
    }
    UIView *animationView = [[UIView alloc]initWithFrame:self.view.bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:animationView];
    NSLog(@"%@",self.animationViewArray);
    [self.animationViewArray addObject:animationView];
    
    // 1.初始化
    POPBasicAnimation *basic = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    // 2.设置初始值
    basic.fromValue = [UIColor clearColor];
    basic.toValue = [UIColor lightGrayColor];
    basic.duration = 0.5;
    
    basic.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    basic.beginTime = CACurrentMediaTime();
    // 3.添加到view上
    [animationView pop_addAnimation:basic forKey:@"colorAnimation"];
    
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    animation.subtype = kCATransitionFromRight;
    animation.type = kCATransitionPush;
    [[selector  layer] addAnimation:animation forKey:@"animationPop"];
    
    [selector setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [[UIApplication sharedApplication].keyWindow addSubview:selector];
}

- (void)removeSelector:(UIView *)selector completeFunction:(SEL)sel{
    [UIView animateWithDuration:0.3 animations:^{
        NSLog(@"%@",self.animationViewArray);
        [self.animationViewArray.lastObject removeFromSuperview];
        [self.animationViewArray removeLastObject];
        [selector setFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
    } completion:^(BOOL finished) {
        if (sel) {
            [self performSelector:sel withObject:nil afterDelay:0];
        }
    }];
}
//- (UIView *)animationView {
//    return objc_getAssociatedObject(self, _cmd);
//}
//- (void)setAnimationView:(UIView *)view {
//    objc_setAssociatedObject(self, @selector(animationView), view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
- (NSMutableArray<UIView *> *)animationViewArray {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setAnimationViewArray:(NSMutableArray<UIView *> *)animationViewArray {
    objc_setAssociatedObject(self, @selector(animationViewArray), animationViewArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
