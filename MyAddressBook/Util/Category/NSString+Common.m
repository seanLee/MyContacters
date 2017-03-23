//
//  NSString+Common.m
//  Coding_iOS
//
//  Created by 王 原闯 on 14-7-31.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import "NSString+Common.h"
#import <CommonCrypto/CommonDigest.h>
#import "sys/utsname.h"
#import "Pinyin.h"

@implementation NSString (Common)
//转换拼音
- (NSString *)transformToPinyin {
    if (self.length <= 0) {
        return self;
    }
    NSString *tempString = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)tempString, NULL, kCFStringTransformToLatin, false);
    tempString = (NSMutableString *)[tempString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    tempString = [tempString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [tempString uppercaseString];
}

- (NSString *)firstPinyinCharacter {
    if (self == nil || [self isEqualToString:@""]) {
        return nil;
    }
    if ([self IsChinese]) {
        char cc = pinyinFirstLetter([self characterAtIndex:0]);
        return [NSString stringWithFormat:@"%c",cc].uppercaseString;
    } else {
        return [self substringToIndex:1].uppercaseString;
    }
}

- (BOOL)IsChinese {
    for(int i = 0; i < [self length]; i++) {
        int a = [self characterAtIndex:i];
        if(a > 0x4e00 && a < 0x9fff) return YES;
    }
    return NO;
}
@end
