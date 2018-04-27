//
//  SelectorBaseView.m
//  HiveApp526
//
//  Created by maybee on 2018/4/20.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import "SelectorBaseView.h"
#import <Masonry.h>
#import "UIView+border.h"
#import "SelectorContentView.h"
#define kIsIPhoneX ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812 ? YES : NO)
#define kStatusBarHeight (kIsIPhoneX ? 44.f : 20.f)
#define kNavBarHeight (kStatusBarHeight + 44)
#define kScreenWidth CGRectGetHeight([UIScreen mainScreen].bounds)
#define kScreenHeight CGRectGetWidth([UIScreen mainScreen].bounds)
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

@interface SelectorBaseView ()<CAAnimationDelegate,SelectorContentViewDelegate>
@property (nonatomic, assign) SelectorBaseViewType currentType;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UITableView * tableview;
@property (nonatomic, strong) SelectorContentView * contentView;

#pragma mark SelectorBaseViewTypeTableView
@property (nonatomic, readonly, strong) NSMutableArray<SelectorMainModel *> *tableDataArray;
@property (nonatomic, readonly, strong) NSMutableArray<SelectorSectionModel *> *collectDataArray;
#pragma mark SelectorBaseViewTypeMutableType
@property (nonatomic, readonly, strong) NSMutableArray<SelectorLeftGroupModel *> *leftDataArray;
@property (nonatomic, readonly, strong) NSMutableArray<SelectorRightItemModel *> *rightDataArray;
#pragma mark SelectorBaseViewTypeMonth
@property (nonatomic, readonly, strong) NSMutableArray<SelectorTimeModel *> *monthDataArray;

@end
@implementation SelectorBaseView
- (instancetype)initTableModeWithTableDataArray:(NSMutableArray<SelectorMainModel *> *)tableDataArray collectDataArray:(NSMutableArray<SelectorSectionModel *> *)collectDataArray{
    NSAssert(tableDataArray.count, @"筛选条件不能为空");
    if (self = [super init]) {
        _tableDataArray = tableDataArray;
        _collectDataArray = collectDataArray;
        self.currentType = SelectorBaseViewTypeTableView;
    }
    return self;
}
- (instancetype)initMutableModeWithLeftDataArray:(NSMutableArray<SelectorLeftGroupModel *> *)leftDataArray rightDataArray:(NSMutableArray<SelectorRightItemModel *> *)rightDataArray{
    NSAssert(leftDataArray.count && rightDataArray.count, @"筛选条件不能为空");
    if (self = [super init]) {
        _leftDataArray = leftDataArray;
        _rightDataArray = rightDataArray;
        self.currentType = SelectorBaseViewTypeMutableType;
    }
    return self;
}
- (instancetype)initMonthModeWithDataArray:(NSMutableArray<SelectorTimeModel *> *)monthDataArray{
    NSAssert(monthDataArray.count, @"筛选条件不能为空");
    if (self = [super init]) {
        _monthDataArray = monthDataArray;
        self.currentType = SelectorBaseViewTypeMonth;
    }
    return self;
}
- (void)setCurrentType:(SelectorBaseViewType)currentType{
    _currentType = currentType;
    [self makeUI];
}
- (void)makeUI{
    UIButton * siderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [siderBtn setBackgroundColor:[UIColor clearColor]];
    [siderBtn addTarget:self action:@selector(backBtnDown) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:siderBtn];
    [self addSubview:self.navView];
    [self addSubview:self.bottomView];
    [self addSubview:self.contentView];
    [siderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self).offset(0);
        make.width.mas_equalTo(31);
    }];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self);
        make.left.equalTo(siderBtn.mas_right);
        make.height.mas_equalTo(kNavBarHeight);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navView.mas_left);
        make.right.bottom.equalTo(self);
        make.height.mas_equalTo((self.currentType == SelectorBaseViewTypeTableView)?45:0);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.navView);
        make.top.equalTo(self.navView.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}
- (void)reloadMainTableWithTableDataArray:(NSMutableArray<SelectorMainModel *> *)tableDataArray{
    [self.contentView reloadMainTableWithTableDataArray:tableDataArray];
}
- (void)backBtnDown{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectorBackBtnDown)]) {
        [self.delegate selectorBackBtnDown];
    }
}
- (void)resetData{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectorResetBtnDown)]) {
        [self.delegate selectorResetBtnDown];
    }
}
- (void)reloadMainTableWithTableDataArray:(NSMutableArray<SelectorMainModel *> *)tableDataArray  collectDataArray:(NSMutableArray<SelectorSectionModel *> *)collectDataArray{
    [self.contentView reloadMainTableWithTableDataArray:tableDataArray collectDataArray:collectDataArray];
}
- (void)confirmBtnDown{
    switch (self.currentType) {
        case SelectorBaseViewTypeTableView:{
            if (self.delegate && [self.delegate respondsToSelector:@selector(selector:ConfirmTableDataArray:collectDataArray:)]) {
                [self.delegate selector:self ConfirmTableDataArray:self.contentView.tableDataArray collectDataArray:self.contentView.collectDataArray];
            }
            break;
        }
        case SelectorBaseViewTypeMutableType:{
            if (self.delegate && [self.delegate respondsToSelector:@selector(selector:ConfirmLeftArray:rightArray:)]) {
                [self.delegate selector:self ConfirmLeftArray:self.contentView.leftDataArray rightArray:self.contentView.rightDataArray];
            }
            break;
        }
        case SelectorBaseViewTypeMonth:{
            if (self.contentView.selectedIndex != -1) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(selector:ConfirmSelectedModel:)]) {
                    [self.delegate selector:self ConfirmSelectedModel:self.contentView.monthDataArray[self.contentView.selectedIndex]];
                }
            }else{
                [self backBtnDown];
            }
            break;
        }
        default:
            break;
    }
}
#pragma mark delegate
- (void)selectorSelectIndex:(NSInteger)index{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectorSelectIndex:)]) {
        [self.delegate selectorSelectIndex:index];
    }
}
#pragma mark lazyLoad
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        resetBtn.layer.borderColor = HexRGBAlpha(0xDEDEDE, 1).CGColor;
        resetBtn.layer.borderWidth = 0.5;
        resetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [resetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [resetBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [resetBtn addTarget:self action:@selector(resetData) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:resetBtn];
        [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(_bottomView);
            make.width.equalTo(_bottomView.mas_width).dividedBy(2);
        }];
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.layer.borderColor = HexRGBAlpha(0xDEDEDE, 1).CGColor;
        confirmBtn.layer.borderWidth = 0.5;
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [confirmBtn setBackgroundImage:[UIImage imageWithColor:kTextTitleBlueColor] forState:UIControlStateNormal];
        confirmBtn.backgroundColor = [UIColor blueColor];
        [confirmBtn addTarget:self action:@selector(confirmBtnDown) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:confirmBtn];
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(_bottomView);
            make.width.equalTo(_bottomView.mas_width).dividedBy(2);
        }];
    }
    return _bottomView;
}
- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc]init];
        _navView.backgroundColor = [UIColor whiteColor];
        [_navView addLine:CGRectMake(0, kNavBarHeight - 1, kScreenWidth - 31, 1) color:[UIColor lightGrayColor]];
        
        [_navView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_navView).offset(-9);
            make.centerX.equalTo(_navView);
            make.height.mas_equalTo(22);
            make.width.mas_equalTo(100);
        }];
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setImage:[[UIImage imageNamed:@"Group Copy"]
                           imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(backBtnDown) forControlEvents:UIControlEventTouchUpInside];
        [_navView addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_navView).offset(0);
            make.left.equalTo(_navView).offset(0);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(44);
        }];
        
        if(_currentType != SelectorBaseViewTypeTableView){
            UIButton *OKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            OKBtn.layer.borderColor = HexRGBAlpha(0xDEDEDE, 1).CGColor;
            OKBtn.layer.borderWidth = 1 * 0.5;
            OKBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [OKBtn setTitle:@"确定" forState:UIControlStateNormal];
            [OKBtn setTitleColor:HexRGBAlpha(0x4A79E2, 1) forState:UIControlStateNormal];
//            [OKBtn setBackgroundImage:[UIImage imageWithColor:kTextTitleBlueColor] forState:UIControlStateNormal];
            [OKBtn addTarget:self action:@selector(confirmBtnDown) forControlEvents:UIControlEventTouchUpInside];
            [_navView addSubview:OKBtn];
            [OKBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_navView).offset(-9);
                make.right.equalTo(_navView).offset(-10);
                make.height.mas_equalTo(22);
                make.width.mas_equalTo(50);
            }];
        }
    }
    return _navView;
}
- (SelectorContentView *)contentView{
    if (!_contentView) {
        switch (self.currentType) {
            case SelectorBaseViewTypeTableView:{
                _contentView = [[SelectorContentView alloc]initTableModeWithTableDataArray:self.tableDataArray collectDataArray:self.collectDataArray];
                break;
            }
            case SelectorBaseViewTypeMutableType:{
                _contentView = [[SelectorContentView alloc]initMutableModeWithLeftDataArray:self.leftDataArray rightDataArray:self.rightDataArray];
                break;
            }
            case SelectorBaseViewTypeMonth:{
                _contentView = [[SelectorContentView alloc]initMonthModeWithDataArray:self.monthDataArray];
                break;
            }
            default:
                break;
        }
        _contentView.delegate = self;
    }
    return _contentView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:19];
    }
    return _titleLabel;
}
@end
