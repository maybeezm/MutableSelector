//
//  SelectorSectionModel.h
//  HiveApp526
//
//  Created by maybee on 2018/4/23.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelectorChooseModel.h"
#import "SelectorChooseModelProtocol.h"
@interface SelectorSectionModel : NSObject<SelectorChooseModelProtocol>

@property (nonatomic, readonly, copy) NSString *itemId;
@property (nonatomic, readonly, copy) NSString *itemTitle;
@property (nonatomic, strong) NSArray<SelectorChooseModel *> *dataArray;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithItemTitle:(NSString *)itemTitle itemId:(NSString *)itemId dataArray:(NSArray<SelectorChooseModel *> *)dataArray;
@end
