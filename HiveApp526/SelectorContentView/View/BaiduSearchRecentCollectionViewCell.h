//
//  EmoReasonSelectCollectionViewCell.h
//  PearPsyEnterprise
//
//  Created by ZhangJC on 16/9/23.
//  Copyright © 2016年 Brightease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectorChooseModel.h"
@interface BaiduSearchRecentCollectionViewCell : UICollectionViewCell
- (void)configCellWithStr:(NSString *)str;
- (void)configCellWithModel:(SelectorChooseModel *)chooseModel;
@end
