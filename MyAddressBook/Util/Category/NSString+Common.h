//
//  NSString+Common.h
//  Coding_iOS
//
//  Created by 王 原闯 on 14-7-31.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)
//转换拼音
- (NSString *)transformToPinyin;
- (NSString *)firstPinyinCharacter;

@end
