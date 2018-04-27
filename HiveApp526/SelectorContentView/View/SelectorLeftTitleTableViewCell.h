//
//  SelectorTitleTableViewCell.h
//  HiveApp526
//
//  Created by maybee on 2018/4/23.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectorLeftGroupModel.h"
#import "SelectorTimeModel.h"
@interface SelectorLeftTitleTableViewCell : UITableViewCell

@property (nonatomic,strong) SelectorLeftGroupModel *model;
@property (nonatomic,strong) SelectorTimeModel *timeModel;

@end
