//
//  SelectorMainModel.m
//  HiveApp526
//
//  Created by maybee on 2018/4/23.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import "SelectorMainModel.h"

@interface SelectorMainModel ()

@property (nonatomic, readwrite, copy) NSString *itemTitle;

@end

@implementation SelectorMainModel

- (instancetype)initWithItemTitle:(NSString *)itemTitle itemDescript:(NSString *)itemDescript selectedArray:(NSArray *)selectedArray{
    if (self = [super init]) {
        self.itemTitle = itemTitle;
        self.itemDescript = itemDescript;
        self.selectedArray = selectedArray;
    }
    return self;
}
- (void)setSelectedArray:(NSArray *)selectedArray{
    _selectedArray = selectedArray;
}
@end
