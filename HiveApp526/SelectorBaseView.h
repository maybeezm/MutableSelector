//
//  SelectorBaseView.h
//  HiveApp526
//
//  Created by maybee on 2018/4/20.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectorMainModel.h"
#import "SelectorSectionModel.h"

#import "SelectorLeftGroupModel.h"
#import "SelectorRightItemModel.h"

#import "SelectorTimeModel.h"

typedef NS_ENUM(NSUInteger, SelectorBaseViewType) {
    //一级页面
    //
    SelectorBaseViewTypeTableView,
    //二级页面
    //机构 BD
    SelectorBaseViewTypeMutableType,
    //月份
    SelectorBaseViewTypeMonth,
};
@protocol SelectorBaseViewDelegate<NSObject>

/**
 点击返回按钮或阴影部分调用返回方法
 */
- (void)selectorBackBtnDown;

@optional
/**
 弹出次级选择框
 */
- (void)selectorSelectIndex:(NSInteger)index;
/**
 确认按钮按下
 */
- (void)selector:(UIView *)selector ConfirmTableDataArray:(NSArray<SelectorMainModel *> *)tableDataArray collectDataArray:(NSArray<SelectorSectionModel *> *)collectDataArray;
- (void)selector:(UIView *)selector ConfirmLeftArray:(NSMutableArray<SelectorLeftGroupModel *> *)leftArray rightArray:(NSMutableArray<SelectorRightItemModel *> *)rightArray;
- (void)selector:(UIView *)selector ConfirmSelectedModel:(SelectorTimeModel *)model;
/**
 重置按钮按下
 */
- (void)selectorResetBtnDown;

@end

@interface SelectorBaseView : UIView

@property (nonatomic,weak) id<SelectorBaseViewDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initTableModeWithTableDataArray:(NSMutableArray<SelectorMainModel *> *)tableDataArray collectDataArray:(NSMutableArray<SelectorSectionModel *> *)collectDataArray;
- (instancetype)initMutableModeWithLeftDataArray:(NSMutableArray<SelectorLeftGroupModel *> *)leftDataArray rightDataArray:(NSMutableArray<SelectorRightItemModel *> *)rightDataArray;
- (instancetype)initMonthModeWithDataArray:(NSMutableArray<SelectorTimeModel *> *)monthDataArray;
- (void)reloadMainTableWithTableDataArray:(NSMutableArray<SelectorMainModel *> *)tableDataArray;
- (void)reloadMainTableWithTableDataArray:(NSMutableArray<SelectorMainModel *> *)tableDataArray  collectDataArray:(NSMutableArray<SelectorSectionModel *> *)collectDataArray;
@end
