//
//  AppDelegate.m
//  RythmSetList
//
//  Created by 今江 健一 on 2024/12/10.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "CreateTable.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //DB作成
    CreateTable *delegateJSON;
    delegateJSON = [[CreateTable alloc] init];
    
    self.dbpath = [delegateJSON createEditableCopyOfDatabaseIfNeeded];  //Create table しながら dbPathも取得
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    /*
     if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
     self.mainView_Iphone = [[MainViewController_iPhone alloc] initWithNibName:@"MainViewController_iPhone" bundle:nil];
     self.window.rootViewController = self.mainView_Iphone;
     } else {
     self.mainView_iPad = [[MainViewController_iPad alloc] initWithNibName:@"MainViewController_iPad" bundle:nil];
     self.window.rootViewController = self.mainView_iPad;
     }
     */
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

#pragma mark -
#pragma mark 変数
- (NSString *)dbpath {
    return dbpath;
}

- (void)setDbpath:(NSString *)aString {
    if ((!dbpath && !aString) || (dbpath && aString && [dbpath isEqualToString:aString])) return;
    dbpath = [aString copy];
}


@end
