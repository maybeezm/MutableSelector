//
//  SelectorChooseTableViewCell.m
//  HiveApp526
//
//  Created by maybee on 2018/4/23.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import "SelectorChooseTableViewCell.h"
#import <Masonry.h>
@interface SelectorChooseTableViewCell ()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *descriptLabel;
@property (nonatomic,strong) UIImageView *arrowImage;

@end

@implementation SelectorChooseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setModel:(SelectorMainModel *)model{
    self.titleLabel.text = model.itemTitle;
    self.descriptLabel.text = model.itemDescript;
}
- (void)makeUI{
    [self addSubview:self.titleLabel];
    [self addSubview:self.descriptLabel];
    [self addSubview:self.arrowImage];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.width.greaterThanOrEqualTo(@50);
        make.height.mas_equalTo(44);
        make.top.bottom.equalTo(self);
    }];
    [self.descriptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(5);
        make.top.bottom.equalTo(self.titleLabel);
    }];
    [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.descriptLabel.mas_right).offset(5);
        make.right.mas_equalTo(-5);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(12);
    }];
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        
    }
    return _titleLabel;
}
- (UILabel *)descriptLabel{
    if (!_descriptLabel) {
        _descriptLabel = [[UILabel alloc]init];
        _descriptLabel.textAlignment = NSTextAlignmentRight;
    }
    return _descriptLabel;
}
- (UIImageView *)arrowImage{
    if (!_arrowImage) {
        _arrowImage = [[UIImageView alloc]init];
        _arrowImage.image = [UIImage imageNamed:@"Group Copy"];
    }
    return _arrowImage;
}
@end
