//
//  customLabel.m
//  PawPaw
//
//  Created by 今江 健一 on 2020/05/03.
//  Copyright © 2020 今江 健一. All rights reserved.
//

#import "customLabel.h"

@implementation customLabel

// 初期化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return self;
    self.borderColor = [UIColor blackColor];
    self.borderWidth = 0;
    self.cornerRadius = 0;
    return self;
}

// 枠の色(設定値を突っ込んで適用)
- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.layer.borderColor = self.borderColor.CGColor;
}

// 枠の太さ(設定値を突っ込んで適用)
- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = self.borderWidth;
}

// 角丸の半径(設定値を突っ込んで適用)
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = self.cornerRadius;
}

//カーニング
- (void)setKerning:(CGFloat)kerning
{
    _kerning = kerning;

    if(self.attributedText)
    {
        NSMutableAttributedString *attribString = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
        [attribString addAttribute:NSKernAttributeName value:@(kerning) range:NSMakeRange(0, self.attributedText.length)];
        self.attributedText = attribString;
     }
}


//上下左右余白
- (void)drawTextInRect:(CGRect)rect{
    UIEdgeInsets insets = UIEdgeInsetsMake(_topPadding, _leftPadding, _bottomPadding, _rightPadding);
    CGRect adjustedRect = UIEdgeInsetsInsetRect(rect, insets);
    [super drawTextInRect:adjustedRect];
}

- (CGSize)intrinsicContentSize{
    CGSize size = [super intrinsicContentSize];
    size.height += (_topPadding + _bottomPadding);
    size.width += (_leftPadding + _rightPadding);

    return size;
}

@end
