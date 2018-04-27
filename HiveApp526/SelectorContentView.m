//
//  SelectorContentView.m
//  HiveApp526
//
//  Created by maybee on 2018/4/20.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import "SelectorContentView.h"
#import "BaiduSearchRecentFlowLayout.h"
#import "BaiduSearchRecentCollectionViewCell.h"
#import <Masonry.h>

#import "SelectorLeftTitleTableViewCell.h"
#import "SelectorChooseTableViewCell.h"
#import "SelectorButtonTableViewCell.h"
#define SPACEINTERVAL 10
@interface SelectorContentView ()<NSObject,UITableViewDelegate,UITableViewDataSource,
                                    UICollectionViewDelegate,UICollectionViewDataSource>
//当前类型
@property (nonatomic, assign) SelectorBaseViewType currentType;
//单选情况下会用到
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, readwrite, strong) NSArray<SelectorRightItemModel *> *rightDataArray;

//SelectorBaseViewTypeTableView 上下结构
@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) UICollectionView *collectionView;
//SelectorBaseViewTypeMutableType 左右结构
@property (nonatomic,strong) UITableView *leftTable;
@property (nonatomic,strong) UITableView *rightTable;
@property (nonatomic,strong) UIButton *allButton;
//SelectorBaseViewTypeMonth 独占
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, readwrite, strong) NSMutableArray<SelectorMainModel *> *tableDataArray;
@property (nonatomic, readwrite, strong) NSMutableArray<SelectorSectionModel *> *collectDataArray;

@end

@implementation SelectorContentView

- (void)setCurrentType:(SelectorBaseViewType)currentType{
    self.backgroundColor = [UIColor whiteColor];
    self.selectedIndex = -1;
    _currentType = currentType;
    switch (currentType) {
        case SelectorBaseViewTypeTableView:{
            [self addSubview:self.scrollview];
            [self.scrollview addSubview:self.contentView];
            [self.contentView addSubview:self.mainTableView];
            [self.contentView addSubview:self.collectionView];
            [self.scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
                make.height.equalTo(self.mas_height).offset(1);
            }];
            [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self.contentView);
                make.width.equalTo(self.mas_width);
                make.height.mas_greaterThanOrEqualTo(10);
            }];
            [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scrollview);
                make.bottom.equalTo(self.contentView.mas_bottom);
                make.width.equalTo(self.mainTableView.mas_width);
                make.top.equalTo(self.mainTableView.mas_bottom);
            }];
            [self.mainTableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionInitial context:nil];
            [self.collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld context:nil];
            [self.mainTableView reloadData];
            [self.collectionView reloadData];
            break;
        }
        case SelectorBaseViewTypeMutableType:{
            self.selectedIndex = 0;
            [self.leftDataArray enumerateObjectsUsingBlock:^(SelectorLeftGroupModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.selected == YES) {
                    self.selectedIndex = idx;
                    self.rightDataArray = obj.subArray;
                    self.allButton.selected = obj.allSelected;
                }
            }];
            [self changeAllButton];
            [self addSubview:self.leftTable];
            [self addSubview:self.rightTable];
            [self.leftTable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self);
                make.width.mas_equalTo(100);
            }];
            [self.rightTable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftTable.mas_right);
                make.top.right.bottom.equalTo(self);
            }];
            break;
        }
        case SelectorBaseViewTypeMonth:{
            [self.monthDataArray enumerateObjectsUsingBlock:^(SelectorTimeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.selected == YES) {
                    self.selectedIndex = idx;
                    *stop = YES;
                }
            }];
            [self addSubview:self.tableView];
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            break;
        }
        default:
            break;
    }
}
- (instancetype)initTableModeWithTableDataArray:(NSMutableArray *)tableDataArray collectDataArray:(NSMutableArray *)collectDataArray{
    NSAssert(tableDataArray.count, @"筛选条件不能为空");
    if (self = [super init]) {
        _tableDataArray = tableDataArray;
        _collectDataArray = collectDataArray;
        self.currentType = SelectorBaseViewTypeTableView;
    }
    return self;
}
- (instancetype)initMutableModeWithLeftDataArray:(NSMutableArray *)leftDataArray rightDataArray:(NSMutableArray *)rightDataArray{
    NSAssert(leftDataArray.count && rightDataArray.count, @"筛选条件不能为空");
    if (self = [super init]) {
        _leftDataArray = leftDataArray;
        _rightDataArray = rightDataArray;
        self.currentType = SelectorBaseViewTypeMutableType;
    }
    return self;
}
- (instancetype)initMonthModeWithDataArray:(NSMutableArray *)monthDataArray{
    NSAssert(monthDataArray.count, @"筛选条件不能为空");
    if (self = [super init]) {
        _monthDataArray = monthDataArray;
        self.currentType = SelectorBaseViewTypeMonth;
    }
    return self;
}
- (void)reloadMainTableWithTableDataArray:(NSMutableArray<SelectorMainModel *> *)tableDataArray{
    self.tableDataArray = tableDataArray;
    [self.mainTableView reloadData];
}
- (void)reloadMainTableWithTableDataArray:(NSMutableArray<SelectorMainModel *> *)tableDataArray  collectDataArray:(NSMutableArray<SelectorSectionModel *> *)collectDataArray{
    self.tableDataArray = tableDataArray;
    self.collectDataArray = collectDataArray;
    [self.mainTableView reloadData];
    [self.collectionView reloadData];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == self.collectionView) {
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_greaterThanOrEqualTo(self.collectionView.contentSize.height);
        }];
    }else{
        [self.mainTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.mainTableView.contentSize.height);
        }];
    }
    if (self.collectionView.contentSize.height + self.mainTableView.contentSize.height > self.frame.size.height && self.frame.size.height != 0) {
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.collectionView.contentSize.height + self.mainTableView.contentSize.height);
        }];
    }else{
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.scrollview.mas_height).offset(1);
        }];
    }
}
- (void)changeAllButton{
    self.allButton.layer.borderColor = self.allButton.selected?[UIColor whiteColor].CGColor:[UIColor blueColor].CGColor;
    self.allButton.backgroundColor = self.allButton.selected?[UIColor blueColor]:[UIColor whiteColor];
}
- (void)titleButtonDown{
    self.allButton.selected = !self.allButton.selected;
    self.leftDataArray[self.selectedIndex].allSelected = self.allButton.selected;
    [self changeAllButton];
    [self.rightDataArray enumerateObjectsUsingBlock:^(SelectorRightItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = self.allButton.selected;
    }];
    [self.rightTable reloadData];
}
#pragma mark collectionViewDelegate & Datasource
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"collectionHeader" forIndexPath:indexPath];
        [headerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor lightGrayColor];
        label.frame = CGRectMake(0, 10, 100, 30);
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        SelectorSectionModel *sectionModel = self.collectDataArray[indexPath.section];
        label.text = sectionModel.itemTitle;
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        [headerView addSubview:label];
        return headerView;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    SelectorSectionModel *sectionModel = self.collectDataArray[indexPath.section];
    SelectorChooseModel *chooseModel = sectionModel.dataArray[indexPath.row];
    return CGSizeMake([self getContentWidthWithStr:chooseModel.itemTitle], 30);
}
- (CGFloat)getContentWidthWithStr:(NSString *)content{
    CGFloat labelWidth = [content boundingRectWithSize:CGSizeMake(200, 11) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
    return labelWidth+30;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.collectDataArray.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SelectorSectionModel *sectionModel = self.collectDataArray[indexPath.section];
    SelectorChooseModel *chooseModel = sectionModel.dataArray[indexPath.row];
    chooseModel.selected = !chooseModel.selected;
    [self.collectionView reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    SelectorSectionModel *sectionModel = self.collectDataArray[section];
    return sectionModel.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BaiduSearchRecentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"emoReasonSelect" forIndexPath:indexPath];
    SelectorSectionModel *sectionModel = self.collectDataArray[indexPath.section];
    [cell configCellWithModel:sectionModel.dataArray[indexPath.row]];
    return cell;
}
#pragma mark tableViewDelegate & dataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.currentType) {
        case SelectorBaseViewTypeTableView:{
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectorSelectIndex:)]) {
                [self.delegate selectorSelectIndex:indexPath.row];
            }
            break;
        }
        case SelectorBaseViewTypeMutableType:{
            if (tableView == self.leftTable) {
                if (indexPath.row == self.selectedIndex) {
                    return;
                }
                if (self.selectedIndex != -1) {
                    SelectorLeftGroupModel *model = self.leftDataArray[self.selectedIndex];
                    model.selected = NO;
                }
                self.selectedIndex = indexPath.row;
                SelectorLeftGroupModel *model = self.leftDataArray[indexPath.row];
                model.selected = YES;
                self.rightDataArray = [model.subArray mutableCopy];
                self.allButton.selected = model.allSelected;
                [self changeAllButton];
                [self.leftTable reloadData];
                [self.rightTable reloadData];
            }else{
                SelectorRightItemModel *item = self.rightDataArray[indexPath.row];
                item.selected = !item.selected;
                __block BOOL isAllSelected = YES;
                __block BOOL isAllCanceled = YES;
                [self.rightDataArray enumerateObjectsUsingBlock:^(SelectorRightItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.selected == YES) {
                        isAllCanceled = NO;
                    }
                    if (obj.selected == NO) {
                        isAllSelected = NO;
                    }
                    if (!isAllSelected && !isAllCanceled) {
                        *stop = YES;
                    }
                }];
                if(isAllSelected != self.leftDataArray[self.selectedIndex].allSelected){
                    self.allButton.selected = isAllSelected;
                    self.leftDataArray[self.selectedIndex].allSelected = self.allButton.selected;
                    [self changeAllButton];
                }
                [self.rightTable reloadData];
            }
            break;
        }
        case SelectorBaseViewTypeMonth:{
            if (indexPath.row == self.selectedIndex) {
                return;
            }
            if (self.selectedIndex != -1) {
                SelectorTimeModel *model = self.monthDataArray[self.selectedIndex];
                model.selected = NO;
            }
            SelectorTimeModel *model = self.monthDataArray[indexPath.row];
            model.selected = YES;
            self.selectedIndex = indexPath.row;
            [self.tableView reloadData];
            break;
        }
        default:
            break;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.currentType) {
        case SelectorBaseViewTypeTableView:{
            return self.tableDataArray.count;
            break;
        }
        case SelectorBaseViewTypeMutableType:{
            if (tableView == self.leftTable) {
                return self.leftDataArray.count;
            }else{
                return self.rightDataArray.count;
            }
            break;
        }
        case SelectorBaseViewTypeMonth:{
            return self.monthDataArray.count;
            break;
        }
        default:
            return 0;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier;
    switch (self.currentType) {
        case SelectorBaseViewTypeTableView:{
            identifier = @"SelectorBaseViewTypeTableView";
            SelectorChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[SelectorChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            [cell setModel:self.tableDataArray[indexPath.row]];
            return cell;
            break;
        }
        case SelectorBaseViewTypeMutableType:{
            if (tableView == self.leftTable) {
                identifier = @"SelectorBaseViewTypeMutableTypeLeft";
                SelectorLeftTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[SelectorLeftTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                [cell setModel:self.leftDataArray[indexPath.row]];
                return cell;
            }else{
                identifier = @"SelectorBaseViewTypeMutableTypeRight";
                SelectorButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[SelectorButtonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                [cell setModel:self.rightDataArray[indexPath.row]];
                return cell;
            }
            break;
        }
        case SelectorBaseViewTypeMonth:{
            identifier = @"SelectorBaseViewTypeMutableTypeLeft";
            SelectorLeftTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[SelectorLeftTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            [cell setModel:self.monthDataArray[indexPath.row]];
            return cell;
            break;
        }
        default:
            return nil;
            break;
    }
}
#pragma mark lazyLoad
////SelectorBaseViewTypeTableView 上下结构
//@property (nonatomic,strong) UITableView *mainTableView;
//@property (nonatomic,strong) UICollectionView *collectionView;
////SelectorBaseViewTypeMutableType 左右结构
//@property (nonatomic,strong) UITableView *leftTable;
//@property (nonatomic,strong) UITableView *rightTable;
////SelectorBaseViewTypeMonth 独占
//@property (nonatomic,strong) UITableView *tableView;
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        BaiduSearchRecentFlowLayout *flowLayout = [[BaiduSearchRecentFlowLayout alloc]init];
        flowLayout.minimumInteritemSpacing = SPACEINTERVAL;
        flowLayout.minimumLineSpacing = SPACEINTERVAL;
        flowLayout.headerReferenceSize = CGSizeMake(self.bounds.size.width, 50.0f);
        _collectionView = [[UICollectionView alloc]initWithFrame:self.frame collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.scrollEnabled = NO;
        _collectionView.userInteractionEnabled = YES;
        [_collectionView registerClass:[BaiduSearchRecentCollectionViewCell class] forCellWithReuseIdentifier:@"emoReasonSelect"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader" withReuseIdentifier:@"collectionHeader"];
    }
    return _collectionView;
}
- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.scrollEnabled = NO;
        _mainTableView.userInteractionEnabled = YES;
        _mainTableView.estimatedRowHeight = 80;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _mainTableView;
}
- (UITableView *)leftTable{
    if (!_leftTable) {
        _leftTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _leftTable.delegate = self;
        _leftTable.dataSource = self;
        _leftTable.estimatedRowHeight = 80;
        _leftTable.rowHeight = UITableViewAutomaticDimension;
    }
    return _leftTable;
}
- (UIScrollView *)scrollview{
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc]init];
        _scrollview.backgroundColor = [UIColor redColor];
    }
    return _scrollview;
}
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor redColor];
//        [_contentView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchDown)]];
    }
    return _contentView;
}
- (UITableView *)rightTable{
    if (!_rightTable) {
        _rightTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _rightTable.delegate = self;
        _rightTable.dataSource = self;
        _rightTable.estimatedRowHeight = 80;
        _rightTable.rowHeight = UITableViewAutomaticDimension;
        
        _rightTable.tableHeaderView = self.allButton;
    }
    return _rightTable;
}
- (UIButton *)allButton{
    if (!_allButton) {
        _allButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _allButton.backgroundColor = [UIColor whiteColor];
        _allButton.layer.borderColor = [UIColor blueColor].CGColor;
        _allButton.layer.borderWidth = 0.5;
        [_allButton setTitle:@"全选" forState:UIControlStateNormal];
        [_allButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_allButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_allButton addTarget:self action:@selector(titleButtonDown) forControlEvents:UIControlEventTouchUpInside];
        _allButton.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 130, 50);
    }
    return _allButton;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 80;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}
- (void)dealloc{
    [self.mainTableView removeObserver:self forKeyPath:@"contentSize"];
    [self.collectionView removeObserver:self forKeyPath:@"contentSize"];
}
@end
