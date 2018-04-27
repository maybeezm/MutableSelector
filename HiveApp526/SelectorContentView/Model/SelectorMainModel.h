//
//  SelectorMainModel.h
//  HiveApp526
//
//  Created by maybee on 2018/4/23.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelectorRightItemModel.h"
#import "SelectorTimeModel.h"
@interface SelectorMainModel : NSObject

@property (nonatomic, readonly, copy) NSString *itemTitle;
@property (nonatomic, copy) NSString *itemDescript;
@property (nonatomic, strong) NSArray<SelectorRightItemModel *> *selectedArray;
@property (nonatomic,strong) SelectorTimeModel *selectedTime;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithItemTitle:(NSString *)itemTitle itemDescript:(NSString *)itemDescript selectedArray:(NSArray *)selectedArray;

@end

