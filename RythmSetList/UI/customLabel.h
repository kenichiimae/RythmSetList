//
//  customLabel.h
//  PawPaw
//
//  Created by 今江 健一 on 2020/05/03.
//  Copyright © 2020 今江 健一. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE

@interface customLabel : UILabel

@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat kerning;

//上下左右余白
@property (nonatomic) IBInspectable CGFloat topPadding;
@property (nonatomic) IBInspectable CGFloat bottomPadding;
@property (nonatomic) IBInspectable CGFloat leftPadding;
@property (nonatomic) IBInspectable CGFloat rightPadding;

@end

NS_ASSUME_NONNULL_END
