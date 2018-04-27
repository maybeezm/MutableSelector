//
//  SelectorLeftGroupModel.m
//  HiveApp526
//
//  Created by maybee on 2018/4/23.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import "SelectorLeftGroupModel.h"

@interface SelectorLeftGroupModel ()

@property (nonatomic, readwrite, copy) NSString *itemId;
@property (nonatomic, readwrite, copy) NSString *itemTitle;

@end

@implementation SelectorLeftGroupModel

- (instancetype)initWithItemTitle:(NSString *)itemTitle itemId:(NSString *)itemId subArray:(NSArray<SelectorRightItemModel *> *)subArray selected:(BOOL)selected allSelected:(BOOL)allSelected{
    if (self = [super init]) {
        self.itemTitle = itemTitle;
        self.itemId = itemId;
        self.subArray = subArray;
        self.selected = selected;
        self.allSelected = allSelected;
    }
    return self;
}

@end
