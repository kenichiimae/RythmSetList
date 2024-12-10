//
//  UIColor+Hex.m
//  Otokoryu
//
//  Created by 今江 健一 on 2020/02/22.
//  Copyright © 2020 今江 健一. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Utils)

+ (id)colorWithHexString:(NSString *)hex alpha:(CGFloat)a {
    hex = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *colorScanner = [NSScanner scannerWithString:hex];
    unsigned int color;
    if (![colorScanner scanHexInt:&color]){
         return nil;
    }
    CGFloat r = ((color & 0xFF0000) >> 16)/255.0f;
    CGFloat g = ((color & 0x00FF00) >> 8) /255.0f;
    CGFloat b =  (color & 0x0000FF) /255.0f;
    //NSLog(@"HEX to RGB >> r:%f g:%f b:%f a:%f\n",r,g,b,a);
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}
@end
