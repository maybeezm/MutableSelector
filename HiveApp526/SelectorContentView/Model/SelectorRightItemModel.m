//
//  SelectorRightItemModel.m
//  HiveApp526
//
//  Created by maybee on 2018/4/23.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import "SelectorRightItemModel.h"

@interface SelectorRightItemModel ()

@property (nonatomic, readwrite, copy) NSString *itemId;
@property (nonatomic, readwrite, copy) NSString *itemTitle;

@end

@implementation SelectorRightItemModel

- (instancetype)initWithItemTitle:(NSString *)itemTitle itemId:(NSString *)itemId selected:(BOOL)selected{
    if (self = [super init]) {
        self.itemTitle = itemTitle;
        self.itemId = itemId;
        self.selected = selected;
    }
    return self;
}

@end
