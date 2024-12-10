//
//  Calc.h
//  JNANail
//
//  Created by 今江 健一 on 2013/06/16.
//  Copyright (c) 2013年 今江 健一. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Calc : NSObject
- (NSString *)strNumberWithValue:(double)motoVal withKanma:(BOOL)KanmaAri forUnderPeriod:(NSInteger)KetaSuu;
- (NSString *)Hiduke:(NSDate *)motoVal withTime:(BOOL)JikanAri withYear:(BOOL)ToshiAri;

@end
