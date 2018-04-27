//
//  SelectorSectionModel.m
//  HiveApp526
//
//  Created by maybee on 2018/4/23.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import "SelectorSectionModel.h"

@interface SelectorSectionModel ()

@property (nonatomic, readwrite, copy) NSString *itemId;
@property (nonatomic, readwrite, copy) NSString *itemTitle;

@end

@implementation SelectorSectionModel

- (instancetype)initWithItemTitle:(NSString *)itemTitle itemId:(NSString *)itemId dataArray:(NSArray<SelectorChooseModel *> *)dataArray{
    if (self = [super init]) {
        self.itemTitle = itemTitle;
        self.itemId = itemId;
        self.dataArray = dataArray;
    }
    return self;
}

@end
