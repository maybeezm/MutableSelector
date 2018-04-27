//
//  SelectorButtonTableViewCell.m
//  HiveApp526
//
//  Created by maybee on 2018/4/23.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import "SelectorButtonTableViewCell.h"
#import <Masonry.h>
@interface SelectorButtonTableViewCell ()

@property (nonatomic,strong) UIButton *titleButton;

@end
@implementation SelectorButtonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeUI];
    }
    return self;
}
- (void)setModel:(SelectorRightItemModel *)model{
    [self.titleButton setTitle:model.itemTitle forState:UIControlStateNormal];
    self.titleButton.selected = model.selected;
    _titleButton.layer.borderColor = self.titleButton.selected?[UIColor whiteColor].CGColor:[UIColor blueColor].CGColor;
    _titleButton.backgroundColor = self.titleButton.selected?[UIColor blueColor]:[UIColor whiteColor];
}
- (void)makeUI{
    [self addSubview:self.titleButton];
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
    }];
}
- (UIButton *)titleButton{
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.backgroundColor = [UIColor whiteColor];
        _titleButton.layer.borderColor = [UIColor blueColor].CGColor;
        _titleButton.layer.borderWidth = 0.5;
        _titleButton.userInteractionEnabled = NO;
        [_titleButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//        [_titleButton addTarget:self action:@selector(titleButtonDown) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}
@end
