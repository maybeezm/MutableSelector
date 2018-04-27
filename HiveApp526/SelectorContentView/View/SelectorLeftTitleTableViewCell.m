//
//  SelectorTitleTableViewCell.m
//  HiveApp526
//
//  Created by maybee on 2018/4/23.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import "SelectorLeftTitleTableViewCell.h"
#import <Masonry.h>

@interface SelectorLeftTitleTableViewCell ()

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation SelectorLeftTitleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeUI];
    }
    return self;
}
- (void)setModel:(SelectorLeftGroupModel *)model{
    _model = model;
    self.titleLabel.text = model.itemTitle;
    self.titleLabel.backgroundColor = model.selected ? [UIColor lightGrayColor] : [UIColor whiteColor];
    self.titleLabel.textColor = model.selected ? [UIColor whiteColor] : [UIColor lightGrayColor];
    
}
- (void)setTimeModel:(SelectorTimeModel *)timeModel{
    _timeModel = timeModel;
    self.titleLabel.text = timeModel.itemTitle;
    self.titleLabel.backgroundColor = timeModel.selected ? [UIColor lightGrayColor] : [UIColor whiteColor];
    self.titleLabel.textColor = timeModel.selected ? [UIColor whiteColor] : [UIColor lightGrayColor];
}
- (void)makeUI{
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.bottom.equalTo(self);
    }];
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
    }
    return _titleLabel;
}
@end
