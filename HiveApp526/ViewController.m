//
//  ViewController.m
//  HiveApp526
//
//  Created by maybee on 2018/4/19.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "ViewModel.h"
#import "UIViewController+Selector.h"
#import "SelectorBaseView.h"

#import "SelectorMainModel.h"
#import "SelectorSectionModel.h"

#import "SelectorLeftGroupModel.h"
#import "SelectorRightItemModel.h"

#import "SelectorTimeModel.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,SelectorBaseViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)SelectorBaseView *selector;
@property (nonatomic, strong)SelectorBaseView *selector1;

@property (nonatomic, strong)NSMutableArray<SelectorMainModel *> *tableDataArray;
@property (nonatomic, strong)NSMutableArray<SelectorSectionModel *> *collectDataArray;
@property (nonatomic, strong)NSMutableArray<SelectorLeftGroupModel *> *leftDataArray;
@property (nonatomic, strong)NSMutableArray<SelectorRightItemModel *> *rightDataArray;
@property (nonatomic, strong)NSMutableArray<SelectorTimeModel *> *MonthdataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc]init];
    [self makeData];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)makeData{
    for (int i = 0; i < 10; i ++) {
        ViewModel *model = [[ViewModel alloc]init];
        model.title = [NSString stringWithFormat:@"%d++%d",i,i];
        model.expand = NO;
        model.array = @[[NSString stringWithFormat:@"%d---0",i],[NSString stringWithFormat:@"%d---1",i],[NSString stringWithFormat:@"%d---2",i]];
        [self.dataArray addObject:model];
    }
}
- (void)selectorSelectIndex:(NSInteger)index{
    if (index == 0) {
        SelectorBaseView *selector = [[SelectorBaseView alloc]initMutableModeWithLeftDataArray:self.leftDataArray rightDataArray:self.leftDataArray.firstObject.subArray];
        selector.tag = 10000 + index;
        self.selector1 = selector;
        selector.delegate = self;
        [self chooseSelector:selector];
    }else if (index == 1){
        SelectorBaseView *selector = [[SelectorBaseView alloc]initMonthModeWithDataArray:self.MonthdataArray];
        selector.tag = 10000 + index;
        self.selector1 = selector;
        selector.delegate = self;
        [self chooseSelector:selector];
    }
    
}
- (void)selectorBackBtnDown{
    if (self.selector1) {
        [self removeSelector:self.selector1 completeFunction:nil];
        self.selector1 = nil;
        return;
    }
    [self removeSelector:self.selector completeFunction:nil];
    self.selector = nil;
}
- (void)selector:(UIView *)selector ConfirmTableDataArray:(NSArray<SelectorMainModel *> *)tableDataArray collectDataArray:(NSArray<SelectorSectionModel *> *)collectDataArray{
    NSMutableString *string = [[NSMutableString alloc]init];
    [tableDataArray enumerateObjectsUsingBlock:^(SelectorMainModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.selectedArray.count) {
            [string appendFormat:@"%@--",obj.itemTitle];
            [obj.selectedArray enumerateObjectsUsingBlock:^(SelectorRightItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [string appendFormat:@"%@,",obj.itemTitle];
            }];
        }else if (obj.selectedTime){
            [string appendFormat:@"%@--",obj.itemTitle];
            [string appendFormat:@"%@--",obj.selectedTime.itemTitle];
        }
    }];
    [collectDataArray enumerateObjectsUsingBlock:^(SelectorSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.dataArray enumerateObjectsUsingBlock:^(SelectorChooseModel * _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj1.selected) {
                [string appendFormat:@"%@,",obj1.itemTitle];
            }
        }];
    }];
    self.contentLabel.text = string;
    [self removeSelector:selector completeFunction:nil];
}
- (void)selector:(UIView *)selector ConfirmLeftArray:(NSMutableArray<SelectorLeftGroupModel *> *)leftArray rightArray:(NSMutableArray<SelectorRightItemModel *> *)rightArray{
    NSMutableArray *selectedArray = [[NSMutableArray alloc]init];
    NSMutableString *string = [[NSMutableString alloc]init];
    [leftArray enumerateObjectsUsingBlock:^(SelectorLeftGroupModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.selected) {
            NSLog(@"obj --- %@ ,id --- %@",obj.itemTitle,obj.itemId);
        }
        [obj.subArray enumerateObjectsUsingBlock:^(SelectorRightItemModel * _Nonnull subObj, NSUInteger subIdx, BOOL * _Nonnull subStop) {
            if (subObj.selected) {
                [selectedArray addObject:subObj];
                NSLog(@"subObj --- %@ ,subId --- %@",subObj.itemTitle,subObj.itemId);
                [string appendFormat:@"%@,",subObj.itemTitle];
            }
        }];
    }];
    if (self.selector1) {
        NSInteger index = selector.tag - 10000;
        self.tableDataArray[index].itemDescript = string;
        self.tableDataArray[index].selectedArray = selectedArray;
        [self.selector reloadMainTableWithTableDataArray:self.tableDataArray];
    }
     [self selectorBackBtnDown];
}
- (void)selector:(UIView *)selector ConfirmSelectedModel:(SelectorTimeModel *)model{
    if (self.selector1) {
        NSInteger index = selector.tag - 10000;
        self.tableDataArray[index].itemDescript = model.itemTitle;
        self.tableDataArray[index].selectedTime = model;
        [self.selector reloadMainTableWithTableDataArray:self.tableDataArray];
    }
    [self selectorBackBtnDown];
    NSLog(@"%@",model.itemTitle);
}
- (void)selectorResetBtnDown{
    [self.tableDataArray enumerateObjectsUsingBlock:^(SelectorMainModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selectedArray = nil;
        obj.selectedTime = nil;
        obj.itemDescript = @"全部";
    }];
    [self.collectDataArray enumerateObjectsUsingBlock:^(SelectorSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.dataArray enumerateObjectsUsingBlock:^(SelectorChooseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
        }];
    }];
    [self.selector reloadMainTableWithTableDataArray:self.tableDataArray collectDataArray:self.collectDataArray];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([self.dataArray[indexPath.row] isKindOfClass:[ViewModel class]]) {
//        ViewModel *model = self.dataArray[indexPath.row];
//        model.expand = !model.expand;
//        if (model.expand) {
//            [self.dataArray insertObjects:model.array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, model.array.count)]];
//        }else{
//            [model.array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                [self.dataArray removeObject:obj];
//            }];
//        }
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }else{
        if (indexPath.row == 0) {
            SelectorBaseView *selector = [[SelectorBaseView alloc]initTableModeWithTableDataArray:self.tableDataArray collectDataArray:nil];
            selector.delegate = self;
            self.selector = selector;
            [self chooseSelector:selector];
        }else if (indexPath.row == 1){
            SelectorBaseView *selector = [[SelectorBaseView alloc]initTableModeWithTableDataArray:self.tableDataArray collectDataArray:self.collectDataArray];
            self.selector = selector;
            selector.delegate = self;
            [self chooseSelector:selector];
        }else if (indexPath.row == 2){
            SelectorBaseView *selector = [[SelectorBaseView alloc]initMutableModeWithLeftDataArray:self.leftDataArray rightDataArray:self.leftDataArray.firstObject.subArray];
            self.selector = selector;
            selector.delegate = self;
            [self chooseSelector:selector];
        }else if (indexPath.row == 3){
            
        }else if (indexPath.row == 4){
            SelectorBaseView *selector = [[SelectorBaseView alloc]initMonthModeWithDataArray:self.MonthdataArray];
            self.selector = selector;
            selector.delegate = self;
            [self chooseSelector:selector];
        }
//    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aaa"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aaa"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([self.dataArray[indexPath.row] isKindOfClass:[ViewModel class]]) {
        ViewModel *model = self.dataArray[indexPath.row];
        cell.textLabel.text = model.title;
    }else{
        cell.textLabel.text = self.dataArray[indexPath.row];
    }
    
    return cell;
}

- (NSMutableArray<SelectorMainModel *> *)tableDataArray{
    if (!_tableDataArray) {
        _tableDataArray = [[NSMutableArray alloc]init];
        for(int i = 0;i < 3;i++){
            SelectorMainModel *model = [[SelectorMainModel alloc]initWithItemTitle:[NSString stringWithFormat:@"aa--%d",i] itemDescript:@"全部" selectedArray:nil];
            [_tableDataArray addObject:model];
        }
    }
    return _tableDataArray;
}
- (NSMutableArray<SelectorSectionModel *> *)collectDataArray{
    if (!_collectDataArray) {
        _collectDataArray = [[NSMutableArray alloc]init];
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for(int i = 0;i < 3;i++){
            SelectorMainModel *model = [[SelectorMainModel alloc]initWithItemTitle:[NSString stringWithFormat:@"aa--%d",i] itemDescript:@"全部" selectedArray:nil];
            [arr addObject:model];
            NSMutableArray *chooseArray = [[NSMutableArray alloc]init];
            for(int j = 0; j < arc4random()%10 ; j ++){
                SelectorChooseModel *chooseModel = [[SelectorChooseModel alloc]initWithItemTitle:[NSString stringWithFormat:@"选项--%d--%d",i,j] itemId:[NSString stringWithFormat:@"%d%d",i,i]];
                [chooseArray addObject:chooseModel];
            }
            SelectorSectionModel *sectionModel = [[SelectorSectionModel alloc]initWithItemTitle:[NSString stringWithFormat:@"bb--%d",i] itemId:[NSString stringWithFormat:@"%d--%d%d",i,i,i] dataArray:chooseArray];
            [_collectDataArray addObject:sectionModel];
        }
    }
    return _collectDataArray;
}
- (NSMutableArray<SelectorLeftGroupModel *> *)leftDataArray{
    if (!_leftDataArray) {
        _leftDataArray = [[NSMutableArray alloc]init];
        for(int i = 0; i < 10; i ++){
            NSMutableArray *subArray = [[NSMutableArray alloc]init];
            for (int j = 0; j < 20; j++) {
                SelectorRightItemModel *itemModel = [[SelectorRightItemModel alloc]initWithItemTitle:[NSString stringWithFormat:@"sub%d--%d",i,j] itemId:[NSString stringWithFormat:@"subId-%d",j] selected:NO];
                [subArray addObject:itemModel];
            }
            SelectorLeftGroupModel *model = [[SelectorLeftGroupModel alloc]initWithItemTitle:[NSString stringWithFormat:@"%d---%d",i,i] itemId:[NSString stringWithFormat:@"%d",i] subArray:subArray selected:(i == 0) allSelected:NO];
            [_leftDataArray addObject:model];
        }
    }
    return _leftDataArray;
}
- (NSMutableArray<SelectorRightItemModel *> *)rightDataArray{
    if (!_rightDataArray) {
        _rightDataArray = [[NSMutableArray alloc]init];
    }
    return _rightDataArray;
}
- (NSMutableArray<SelectorTimeModel *> *)MonthdataArray{
    if (!_MonthdataArray) {
        _MonthdataArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < 10; i ++) {
            SelectorTimeModel *model = [[SelectorTimeModel alloc]initWithItemTitle:[NSString stringWithFormat:@"Time--%d",i] itemId:[NSString stringWithFormat:@"bb--%d%d",i,i]];
            [_MonthdataArray addObject:model];
        }
    }
    return _MonthdataArray;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 80;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
        self.contentLabel.numberOfLines = 0;
        _tableView.tableFooterView = self.contentLabel;
    }
    return _tableView;
}

@end
