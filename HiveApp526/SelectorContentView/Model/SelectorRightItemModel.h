//
//  SelectorRightItemModel.h
//  HiveApp526
//
//  Created by maybee on 2018/4/23.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelectorChooseModelProtocol.h"

@interface SelectorRightItemModel : NSObject<SelectorChooseModelProtocol>

@property (nonatomic, readonly, copy) NSString *itemId;
@property (nonatomic, readonly, copy) NSString *itemTitle;
@property (nonatomic, assign) BOOL selected;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithItemTitle:(NSString *)itemTitle itemId:(NSString *)itemId selected:(BOOL)selected;
@end
