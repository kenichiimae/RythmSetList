//
//  TitleTableViewCell.m
//  RythmSetList
//
//  Created by 今江 健一 on 2024/12/10.
//

#import "TitleTableViewCell.h"

@implementation TitleTableViewCell
@synthesize lblTitle, lblContents;

- (void)dealloc{
    lblTitle = nil;
    lblContents = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
