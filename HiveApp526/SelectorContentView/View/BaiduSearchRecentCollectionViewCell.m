//
//  EmoReasonSelectCollectionViewCell.m
//  PearPsyEnterprise
//
//  Created by ZhangJC on 16/9/23.
//  Copyright © 2016年 Brightease. All rights reserved.
//

#import "BaiduSearchRecentCollectionViewCell.h"
#import <Masonry.h>
@interface BaiduSearchRecentCollectionViewCell()
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation BaiduSearchRecentCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor =  [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        _titleLabel.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1/1.0];
        _titleLabel.layer.cornerRadius = 5;
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (void)layoutSubviews{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super layoutSubviews];
}
- (void)configCellWithStr:(NSString *)str{
    _titleLabel.text = str;
}
- (void)configCellWithModel:(SelectorChooseModel *)chooseModel{
    _titleLabel.text = chooseModel.itemTitle;
    if(chooseModel.selected){
        
    }
    _titleLabel.textColor = chooseModel.selected ? [UIColor whiteColor]:[UIColor blueColor];
    _titleLabel.backgroundColor = chooseModel.selected ? [UIColor blueColor]:[UIColor whiteColor];
}
@end
