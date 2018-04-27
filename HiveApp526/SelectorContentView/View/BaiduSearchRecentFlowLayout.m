//
//  EmoReasonSelectFlowLayout.m
//  PearPsyEnterprise
//
//  Created by ZhangJC on 16/9/23.
//  Copyright © 2016年 Brightease. All rights reserved.
//

#import "BaiduSearchRecentFlowLayout.h"

@implementation BaiduSearchRecentFlowLayout
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray* attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    for(int i = 1; i < [attributes count]; ++i) {
        //当前attributes
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        //上一个attributes
        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
        //我们想设置的最大间距，可根据需要改
        NSInteger maximumSpacing = 15;
        //前一个cell的最右边
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
        //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后一个元素的后面了
        if (i == 1) {
            CGRect frame = prevLayoutAttributes.frame;
            frame.origin.x = 0;
            prevLayoutAttributes.frame = frame;
            [attributes replaceObjectAtIndex:0 withObject:prevLayoutAttributes];
        }
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width <= self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            if (currentLayoutAttributes.indexPath.section != prevLayoutAttributes.indexPath.section) {
                frame.origin.x = 0;
            NSLog(@"curr - %d----prev - %d",currentLayoutAttributes.indexPath.section,prevLayoutAttributes.indexPath.section);
                frame.origin.y = prevLayoutAttributes.frame.origin.y + 50 + prevLayoutAttributes.frame.size.height;
            }else if(prevLayoutAttributes.frame.origin.x < frame.origin.x && prevLayoutAttributes.frame.origin.y > frame.origin.y){
                frame.origin.y = prevLayoutAttributes.frame.origin.y;
            }
            currentLayoutAttributes.frame = frame;
            [attributes replaceObjectAtIndex:i withObject:currentLayoutAttributes];
        }else{
            CGRect frame = currentLayoutAttributes.frame;
            if(frame.origin.x != 0){
                frame.origin.x = 0;
                frame.origin.y = frame.origin.y + frame.size.height + 10;
            }
            
            currentLayoutAttributes.frame = frame;
            [attributes replaceObjectAtIndex:i withObject:currentLayoutAttributes];
        }
    }
    return attributes;
}
- (CGSize)collectionViewContentSize{
    return [super collectionViewContentSize];
}
@end
