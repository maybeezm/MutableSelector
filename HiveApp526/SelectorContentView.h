//
//  SelectorContentView.h
//  HiveApp526
//
//  Created by maybee on 2018/4/20.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectorBaseView.h"

#import "SelectorMainModel.h"
#import "SelectorSectionModel.h"

#import "SelectorLeftGroupModel.h"
#import "SelectorRightItemModel.h"

#import "SelectorTimeModel.h"
@protocol SelectorContentViewDelegate<NSObject>

- (void)selectorSelectIndex:(NSInteger)index;

@end

@interface SelectorContentView : UIView
@property (nonatomic, readonly, strong) UIView *contentView;
@property (nonatomic, weak) id<SelectorContentViewDelegate> delegate;
#pragma mark SelectorBaseViewTypeTableView
@property (nonatomic, readonly, strong) NSMutableArray<SelectorMainModel *> *tableDataArray;
@property (nonatomic, readonly, strong) NSMutableArray<SelectorSectionModel *> *collectDataArray;
#pragma mark SelectorBaseViewTypeMutableType
@property (nonatomic, readonly, strong) NSMutableArray<SelectorLeftGroupModel *> *leftDataArray;
@property (nonatomic, readonly, strong) NSArray<SelectorRightItemModel *> *rightDataArray;
#pragma mark SelectorBaseViewTypeMonth
@property (nonatomic, readonly, strong) NSMutableArray<SelectorTimeModel *> *monthDataArray;
@property (nonatomic, readonly, assign) NSInteger selectedIndex;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initTableModeWithTableDataArray:(NSMutableArray<SelectorMainModel *> *)tableDataArray collectDataArray:(NSMutableArray<SelectorSectionModel *> *)collectDataArray;
- (instancetype)initMutableModeWithLeftDataArray:(NSMutableArray<SelectorLeftGroupModel *> *)leftDataArray rightDataArray:(NSMutableArray<SelectorRightItemModel *> *)rightDataArray;
- (instancetype)initMonthModeWithDataArray:(NSMutableArray<SelectorTimeModel *> *)monthDataArray;
- (void)reloadMainTableWithTableDataArray:(NSMutableArray<SelectorMainModel *> *)tableDataArray;
- (void)reloadMainTableWithTableDataArray:(NSMutableArray<SelectorMainModel *> *)tableDataArray  collectDataArray:(NSMutableArray<SelectorSectionModel *> *)collectDataArray;
@end
