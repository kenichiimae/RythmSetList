//
//  AppDelegate.h
//  RythmSetList
//
//  Created by 今江 健一 on 2024/12/10.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSString *dbpath;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;

@property (copy, nonatomic) NSString *dbpath;


@end

