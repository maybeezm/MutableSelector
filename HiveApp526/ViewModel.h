//
//  ViewModel.h
//  HiveApp526
//
//  Created by maybee on 2018/4/19.
//  Copyright © 2018年 maybee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewModel : NSObject
@property (nonatomic, copy)NSString *title;
@property (nonatomic, assign)BOOL expand;
@property (nonatomic, strong)NSArray *array;
@end
