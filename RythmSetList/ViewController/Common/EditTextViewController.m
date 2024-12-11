//
//  EditTextViewController.m
//  PawPaw
//
//  Created by 今江 健一 on 2020/05/29.
//  Copyright © 2020 今江 健一. All rights reserved.
//

#import "EditTextViewController.h"
#import "UIColor+Hex.h"
#define kSlideSpeed         0.2

@interface EditTextViewController (){
    IBOutlet UITextField *txtSingle;
    IBOutlet UILabel *lblTitle;
    IBOutlet UITextField *txtSingle2;
    IBOutlet UILabel *lblTitle2;
    IBOutlet UIView *viewMain;
    IBOutlet UIView *viewTopSafeSpace;
    IBOutlet UIButton *btnRegister;
}

@end

@implementation EditTextViewController

- (void)dealloc{
    viewMain = nil;
    txtSingle2 = nil;
    lblTitle2 = nil;
    txtSingle = nil;
    lblTitle = nil;
    strText = nil;
    strTitle = nil;
}

#pragma mark -
#pragma mark 起動時
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self->viewMain.hidden = YES;
    lblTitle.text = strTitle;
    txtSingle.text = strText;
    txtSingle.placeholder = strPlaceHolder;
    
    lblTitle2.text = strTitle2;
    txtSingle2.text = strText2;
    txtSingle2.placeholder = strPlaceHolder2;

    if (intEditID == 0){
        [btnRegister setTitle:NSLocalizedString(@"register", @"") forState:UIControlStateNormal];
    }else{
        [btnRegister setTitle:NSLocalizedString(@"update", @"") forState:UIControlStateNormal];
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    self->viewMain.center = CGPointMake(self->viewMain.center.x, - self->viewMain.bounds.size.height / 2 ) ;
    viewMain.hidden = NO;
    [self showItemView];
}

#pragma mark -
#pragma mark 選択部分を表示
- (void)showItemView{
    [UIView animateWithDuration:kSlideSpeed animations:^{
        self->viewMain.center = CGPointMake(self->viewMain.center.x, self->viewTopSafeSpace.bounds.size.height + 20 + self->viewMain.bounds.size.height / 2) ;

    } completion:^(BOOL finished){
        if (finished) {
            [self->txtSingle becomeFirstResponder];
        }
    }];

}

#pragma mark -
#pragma mark 選択部分を閉じる
- (void)closeSelectViewForCancel:(BOOL)flgForCancel{
    if (flgCantClose && flgForCancel){
        return;
    }
    
    [UIView animateWithDuration:kSlideSpeed animations:^{
        self->viewMain.center = CGPointMake(self->viewMain.center.x, - self->viewMain.bounds.size.height / 2 ) ;

    } completion:^(BOOL finished){
        if (finished) {
            if (flgForCancel) {
                [self.delegate EditTextViewControllerDidCancel:self];
            }else{
                [self.delegate EditTextViewControllerDidSave:self];
            }
        }
    }];

}

#pragma mark -
#pragma mark シングルテキストの完了
- (IBAction)firstEdited:(id)sender{
    [txtSingle2 becomeFirstResponder];
}

- (IBAction)secondEdited:(id)sender{
    [txtSingle2 resignFirstResponder];
}


#pragma mark -
#pragma mark 確定
- (IBAction)decideText:(id)sender{
    strText = txtSingle.text;
    strText2 = txtSingle2.text;
    [self closeSelectViewForCancel:NO];
}

#pragma mark -
#pragma mark 画面タップでキャンセル
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([touches count] == 1) {
        NSArray *allTouches = [touches allObjects]; // 全タッチ情報を取得
        UITouch *first = [allTouches objectAtIndex:0];
        if ([first locationInView:self.view].y < viewMain.center.y - viewMain.bounds.size.height / 2 || [first locationInView:self.view].y > viewMain.center.y + viewMain.bounds.size.height / 2 || [first locationInView:self.view].x < viewMain.center.x - viewMain.bounds.size.width / 2 || [first locationInView:self.view].x > viewMain.center.x + viewMain.bounds.size.width / 2) {
            [self closeSelectViewForCancel:YES];
        }
    }
}

#pragma mark -
#pragma mark 変数
- (NSInteger)intEditID {
    return intEditID;
}

- (void)setIntEditID:(NSInteger)aInt {
    if ((!intEditID && !aInt) || (intEditID == aInt)) return;
    intEditID = aInt;
}

- (NSString *)strText {
    return strText;
}

- (void)setStrText:(NSString *)aString {
    if ((!strText && !aString) || (strText && aString && [strText isEqualToString:aString])) return;
    strText = nil;
    strText = [aString copy];
}

- (NSString *)strTitle {
    return strTitle;
}

- (void)setStrTitle:(NSString *)aString {
    if ((!strTitle && !aString) || (strTitle && aString && [strTitle isEqualToString:aString])) return;
    strTitle = nil;
    strTitle = [aString copy];
}

- (NSString *)strPlaceHolder {
    return strPlaceHolder;
}

- (void)setStrPlaceHolder:(NSString *)aString {
    if ((!strPlaceHolder && !aString) || (strPlaceHolder && aString && [strPlaceHolder isEqualToString:aString])) return;
    strPlaceHolder = nil;
    strPlaceHolder = [aString copy];
}

- (NSString *)strText2 {
    return strText2;
}

- (void)setStrText2:(NSString *)aString {
    if ((!strText2 && !aString) || (strText2 && aString && [strText2 isEqualToString:aString])) return;
    strText2 = nil;
    strText2 = [aString copy];
}

- (NSString *)strTitle2 {
    return strTitle2;
}

- (void)setStrTitle2:(NSString *)aString {
    if ((!strTitle2 && !aString) || (strTitle2 && aString && [strTitle2 isEqualToString:aString])) return;
    strTitle2 = nil;
    strTitle2 = [aString copy];
}

- (NSString *)strPlaceHolder2 {
    return strPlaceHolder2;
}

- (void)setStrPlaceHolder2:(NSString *)aString {
    if ((!strPlaceHolder2 && !aString) || (strPlaceHolder2 && aString && [strPlaceHolder2 isEqualToString:aString])) return;
    strPlaceHolder2 = nil;
    strPlaceHolder2 = [aString copy];
}

- (BOOL)flgCantClose {
    return flgCantClose;
}

- (void)setFlgCantClose:(BOOL)aBool {
    if ((!flgCantClose && !aBool) || (flgCantClose == aBool)) return;
    flgCantClose = aBool;
}


@end
