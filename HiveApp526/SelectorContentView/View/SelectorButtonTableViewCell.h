//
//  SelectorButtonTableViewCell.h
//  HiveApp526
//
//  Created by maybee on 2018/4/23.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectorRightItemModel.h"
#import "SelectorChooseModelProtocol.h"

@protocol SelectorButtonTableViewCellDelegate<NSObject>

- (void)buttonDownWithModel:(id<SelectorChooseModelProtocol>)model;

@end

@interface SelectorButtonTableViewCell : UITableViewCell

@property (nonatomic,strong) SelectorRightItemModel *model;

@end
