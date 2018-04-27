//
//  Header.h
//  HiveApp526
//
//  Created by maybee on 2018/4/23.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@protocol SelectorChooseModelProtocol <NSObject>

@property (nonatomic, readonly, copy) NSString *itemId;
@property (nonatomic, readonly, copy) NSString *itemTitle;
@optional
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, readonly,strong) NSArray<id<SelectorChooseModelProtocol>> *subArray;

@end
