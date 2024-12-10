//
//  UIColor+Hex.h
//  Otokoryu
//
//  Created by 今江 健一 on 2020/02/22.
//  Copyright © 2020 今江 健一. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Utils)

+ (id)colorWithHexString:(NSString *)hex alpha:(CGFloat)a;
@end

NS_ASSUME_NONNULL_END
