//
//  SelectorChooseModel.m
//  HiveApp526
//
//  Created by maybee on 2018/4/23.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import "SelectorChooseModel.h"

@interface SelectorChooseModel ()

@property (nonatomic, readwrite, copy) NSString *itemId;
@property (nonatomic, readwrite, copy) NSString *itemTitle;

@end

@implementation SelectorChooseModel

- (instancetype)initWithItemTitle:(NSString *)itemTitle itemId:(NSString *)itemId{
    if (self = [super init]) {
        self.itemTitle = itemTitle;
        self.itemId = itemId;
    }
    return self;
}

@end
