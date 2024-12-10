//
//  TitleTableViewCell.h
//  RythmSetList
//
//  Created by 今江 健一 on 2024/12/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TitleTableViewCell : UITableViewCell{
    IBOutlet UILabel *lblTitle;
    IBOutlet UILabel *lblContents;

}
@property (nonatomic, retain) UILabel *lblTitle;
@property (nonatomic, retain) UILabel *lblContents;

@end

NS_ASSUME_NONNULL_END
