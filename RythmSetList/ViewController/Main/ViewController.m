//
//  ViewController.m
//  RythmSetList
//
//  Created by 今江 健一 on 2024/12/10.
//

#import "ViewController.h"
#import "EditTextViewController.h"
#import "AppDelegate.h"

@interface ViewController ()<EditTextViewControllerDelegate>{
    AppDelegate *applicationDelegate;
    
    IBOutlet UITableView *tblMain;

}

@end

@implementation ViewController

- (void)dealloc{
    tblMain = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    applicationDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
}

#pragma mark -
#pragma mark 追加
- (IBAction)addMusic:(id)sender{
    EditTextViewController *editView = [[UIStoryboard storyboardWithName:kSBCommon bundle:nil]instantiateViewControllerWithIdentifier:@"EditTextViewController"];
    editView.strTitle = NSLocalizedString(@"titleSongName", @"");
    editView.strTitle2 = NSLocalizedString(@"titleSpeed", @"");
    editView.strPlaceHolder = NSLocalizedString(@"placeHSongName", @"");
    editView.strPlaceHolder2 = NSLocalizedString(@"placeHTitleSpeed", @"");
    editView.delegate = self;
    [self presentViewController:editView animated:NO completion:nil];

}

- (void) EditTextViewControllerDidCancel: (EditTextViewController *) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) EditTextViewControllerDidSave: (EditTextViewController *) controller{
    [tblMain reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
