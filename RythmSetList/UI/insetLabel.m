//
//  insetLabel.m
//  PawPaw
//
//  Created by 今江 健一 on 2020/06/23.
//  Copyright © 2020 今江 健一. All rights reserved.
//

#import "insetLabel.h"

@implementation insetLabel

UIEdgeInsets insets = {0, 2, 0, 2};

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (CGSize)intrinsicContentSize{
    CGSize sizeOrigin = [super intrinsicContentSize];
    sizeOrigin.height += insets.top + insets.bottom;
    sizeOrigin.width += insets.left * insets.right;
    return sizeOrigin;
}
@end
