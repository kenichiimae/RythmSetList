//
//  EditTextViewController.h
//  PawPaw
//
//  Created by 今江 健一 on 2020/05/29.
//  Copyright © 2020 今江 健一. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EditTextViewControllerDelegate; // forward declaration
@interface EditTextViewController : UIViewController{
    NSString *strTitle;
    NSString *strText;
    NSString *strTitle2;
    NSString *strText2;
    NSString *strPlaceHolder;  //とりあえずシングルテキストだけ
    NSString *strPlaceHolder2;  //とりあえずシングルテキストだけ
    BOOL flgAddNew;
    BOOL flgCantClose;
}
@property (nonatomic, assign) id <EditTextViewControllerDelegate>    delegate;
@property (copy, nonatomic) NSString *strTitle;
@property (copy, nonatomic) NSString *strText;
@property (copy, nonatomic) NSString *strTitle2;
@property (copy, nonatomic) NSString *strText2;
@property (copy, nonatomic) NSString *strPlaceHolder;
@property (copy, nonatomic) NSString *strPlaceHolder2;
@property (nonatomic) BOOL flgAddNew;
@property (nonatomic) BOOL flgCantClose;

@end

@protocol EditTextViewControllerDelegate
- (void) EditTextViewControllerDidCancel: (EditTextViewController *) controller;
- (void) EditTextViewControllerDidSave: (EditTextViewController *) controller;
@end

NS_ASSUME_NONNULL_END
