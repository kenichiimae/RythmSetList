//
//  ViewController.m
//  RythmSetList
//
//  Created by 今江 健一 on 2024/12/10.
//

#import "ViewController.h"
#import "EditTextViewController.h"
#import "AppDelegate.h"
#import "DataRhythm.h"
#import "TitleTableViewCell.h"
#import "Calc.h"

@interface ViewController ()<EditTextViewControllerDelegate>{
    AppDelegate *applicationDelegate;
    Calc *clsCalc;

    IBOutlet UITableView *tblMain;
    IBOutlet UIButton *btnEdit;
    IBOutlet UILabel *lblSongTitle;
    IBOutlet UILabel *lblTempo;
    IBOutlet UIImageView *imgFlash;
    IBOutlet UIButton *btnNextSong;
    
    NSMutableArray *arrSongs;
    
    BOOL flgTableEditing;
    
    NSInteger intSelectedTempo;

    NSTimer *tmrAnime;
    BOOL TimerMoving;
    
    int intSelectedTableRowNo;
}

@end

@implementation ViewController

#pragma mark -
#pragma mark 基本・初期動作
- (void)dealloc{
    tblMain = nil;
    btnEdit = nil;
    lblSongTitle = nil;
    lblTempo = nil;
    imgFlash = nil;
    btnNextSong = nil;
    arrSongs = nil;
    applicationDelegate = nil;
    clsCalc = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [btnNextSong setTitle:@"" forState:UIControlStateNormal];
    
    applicationDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    clsCalc = [[Calc alloc] init];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    intSelectedTableRowNo = -1;
    [self showList];
}

#pragma mark -
#pragma mark 表示
- (void)showList{
    DataRhythm *cDts = [[DataRhythm alloc] init];
    arrSongs = [cDts getSongList];
    [tblMain reloadData];
    if (intSelectedTableRowNo == -1) {
        if ([arrSongs count] >= 0) {
            intSelectedTableRowNo = 0;
            [self selectedSongWithIndex:intSelectedTableRowNo];
        }
    }

    cDts = nil;
}

#pragma mark -
#pragma mark 追加
- (IBAction)addMusic:(id)sender{
    EditTextViewController *editView = [[UIStoryboard storyboardWithName:kSBCommon bundle:nil]instantiateViewControllerWithIdentifier:@"EditTextViewController"];
    editView.strTitle = NSLocalizedString(@"titleSongName", @"");
    editView.strTitle2 = NSLocalizedString(@"titleSpeed", @"");
    editView.strPlaceHolder = NSLocalizedString(@"placeHSongName", @"");
    editView.strPlaceHolder2 = NSLocalizedString(@"placeHTitleSpeed", @"");
    editView.intEditID = 0;
    editView.delegate = self;
    [self presentViewController:editView animated:NO completion:nil];

}

- (void) EditTextViewControllerDidCancel: (EditTextViewController *) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) EditTextViewControllerDidSave: (EditTextViewController *) controller{
    DataRhythm *cDts = [[DataRhythm alloc] init];
    if (controller.intEditID == 0) {
        //新規追加
        [cDts addItemWithTempo:[controller.strText2 intValue] andTitle:controller.strText];
    }else{
        [cDts updateItemWithTempo:[controller.strText2 intValue] andTitle:controller.strText withItemID:controller.intEditID];
    }
    cDts = nil;
    [self showList];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark テーブル表示関連
//　テーブルのセクションの数を返す
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

// テーブルのレコード数を返す
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrSongs count];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return flgTableEditing;
}

// このメソッドはテーブルのレコード数だけループして呼ばれる。
// indexPathにはループのセル番号（0スタート）が入る
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType= UITableViewCellAccessoryDetailButton;

    DataRhythm *bookData = (DataRhythm *)[arrSongs objectAtIndex:indexPath.row];

    cell.lblTitle.text = bookData.strTitle;
    cell.lblContents.text = [clsCalc strNumberWithValue:bookData.intTempo withKanma:YES forUnderPeriod:0];
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self selectedSongWithIndex:indexPath.row];
}

//アクセサリーをタップすると、以下のUITableViewのデリゲートが呼ばれます。ここに詳細ビューへの切り替え処理を実装します。
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    DataRhythm *bookData = (DataRhythm *)[arrSongs objectAtIndex:indexPath.row];
    EditTextViewController *controller = [[UIStoryboard storyboardWithName:kSBCommon bundle:nil]instantiateViewControllerWithIdentifier:@"EditTextViewController"];
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    controller.delegate = self;
    controller.intEditID = bookData.primaryKey;
    controller.strText = bookData.strTitle;
    controller.strText2 = [clsCalc strNumberWithValue:bookData.intTempo withKanma:YES forUnderPeriod:0];
    controller.strTitle = NSLocalizedString(@"titleSongName", @"");
    controller.strTitle2 = NSLocalizedString(@"titleSpeed", @"");
    controller.strPlaceHolder = NSLocalizedString(@"placeHSongName", @"");
    controller.strPlaceHolder2 = NSLocalizedString(@"placeHTitleSpeed", @"");
    [self presentViewController:controller animated:NO completion:nil];

}
// 移動後の後処理
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    //NSLog(@"from=%d",sourceIndexPath.row);
    //NSLog(@"to=%d",destinationIndexPath.row);
    sqlite3 *database;
    if (sqlite3_open([applicationDelegate.dbpath UTF8String], &database) == SQLITE_OK) {
        const char *sql;
        DataRhythm *bookData;
        int fromID;
        int toOrder;
        if (sourceIndexPath.row<destinationIndexPath.row) {
            bookData = (DataRhythm *)[arrSongs objectAtIndex:sourceIndexPath.row];
            fromID = (int)bookData.primaryKey;
            bookData = (DataRhythm *)[arrSongs objectAtIndex:destinationIndexPath.row];
            toOrder = (int)bookData.intSortOrder;
            //NSLog(@"UPDATE dt_Category SET IndicateOrder = %d WHERE CategoryID = %d;",toOrder,fromID);
            sql=[[NSString stringWithFormat: @"UPDATE data_Rhythm SET int_SortOrder = %d WHERE int_RhythmID = %d;",toOrder,fromID] cStringUsingEncoding:NSUTF8StringEncoding];
            sqlite3_exec( database, sql, 0, 0, NULL );
            for (int i=(int)sourceIndexPath.row+1; i<=destinationIndexPath.row; i++) {
                bookData = (DataRhythm *)[arrSongs objectAtIndex:i];
                fromID = (int)bookData.primaryKey;
                bookData = (DataRhythm *)[arrSongs objectAtIndex:i-1];
                toOrder = (int)bookData.intSortOrder;
                sql=[[NSString stringWithFormat: @"UPDATE data_Rhythm SET int_SortOrder = %d WHERE int_RhythmID = %d;",toOrder,fromID] cStringUsingEncoding:NSUTF8StringEncoding];
                sqlite3_exec( database, sql, 0, 0, NULL );
                //NSLog(@"UPDATE dt_Category SET IndicateOrder = %d WHERE CategoryID = %d;",toOrder,fromID);
            }
        }else {
            bookData = (DataRhythm *)[arrSongs objectAtIndex:sourceIndexPath.row];
            fromID = (int)bookData.primaryKey;
            bookData = (DataRhythm *)[arrSongs objectAtIndex:destinationIndexPath.row];
            toOrder = (int)bookData.intSortOrder;
            sql=[[NSString stringWithFormat: @"UPDATE data_Rhythm SET int_SortOrder = %d WHERE int_RhythmID = %d;",toOrder,fromID] cStringUsingEncoding:NSUTF8StringEncoding];
            //NSLog(@"UPDATE dt_Category SET IndicateOrder = %d WHERE CategoryID = %d;",toOrder,fromID);
            sqlite3_exec( database, sql, 0, 0, NULL );
            for (int i=(int)destinationIndexPath.row; i<sourceIndexPath.row; i++) {
                bookData = (DataRhythm *)[arrSongs objectAtIndex:i];
                fromID = (int)bookData.primaryKey;
                bookData = (DataRhythm *)[arrSongs objectAtIndex:i+1];
                toOrder = (int)bookData.intSortOrder;
                sql=[[NSString stringWithFormat: @"UPDATE data_Rhythm SET int_SortOrder = %d WHERE int_RhythmID = %d;",toOrder,fromID] cStringUsingEncoding:NSUTF8StringEncoding];
                //NSLog(@"UPDATE dt_Category SET IndicateOrder = %d WHERE CategoryID = %d;",toOrder,fromID);
                sqlite3_exec( database, sql, 0, 0, NULL );
            }
        }
    }
    sqlite3_close( database );
    [self showList];
}

//別セクションまで移動しないように
- (NSIndexPath *)tableView:(UITableView *)tableView
targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        return sourceIndexPath;
    }else{
        return proposedDestinationIndexPath;
    }
}

- (void)selectedSongWithIndex:(NSInteger)intRowNo{
    DataRhythm *bookData = (DataRhythm *)[arrSongs objectAtIndex:intRowNo];
    lblSongTitle.text = bookData.strTitle;
    lblTempo.text = [clsCalc strNumberWithValue:bookData.intTempo withKanma:YES forUnderPeriod:0];
    NSIndexPath *idx = [[NSIndexPath alloc] initWithIndex:intSelectedTableRowNo];
    [tblMain selectRowAtIndexPath:idx animated:NO scrollPosition:UITableViewScrollPositionTop];

    [self StopTimer];
    intSelectedTempo = (int)bookData.intTempo;
    [self StartTimer];

}

#pragma mark -
#pragma mark データ削除
- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DataRhythm *bookData = (DataRhythm *)[arrSongs objectAtIndex:indexPath.row];
        [self removeItemMaster:bookData];
        // Animate the deletion from the table.
        [tblMain deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)removeItemMaster:(DataRhythm *)catdata{
    sqlite3 *database;
    if (sqlite3_open([applicationDelegate.dbpath UTF8String], &database) == SQLITE_OK) {
        [catdata deleteFromDatabaseDatabase:database];
        [arrSongs removeObject:catdata];
        [DataRhythm finalizeStatements];
    }
    sqlite3_close(database);
}

#pragma mark -
#pragma mark データ編集
- (IBAction)dataEdit:(id)sender{
    if (flgTableEditing == YES) {
        flgTableEditing = NO;
        [btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
    }else{
        flgTableEditing = YES;
        [btnEdit setTitle:@"Done" forState:UIControlStateNormal];
    }
    tblMain.editing = flgTableEditing;
    [tblMain reloadData];
}

#pragma mark -
#pragma mark タイマー関係
- (void)setTmrAnime:(NSTimer *)newTimer {
    [tmrAnime invalidate];
    tmrAnime = newTimer;
}

- (void)StopTimer{
    if (TimerMoving == TRUE) {
        TimerMoving = FALSE;
        [tmrAnime invalidate];
        self.tmrAnime =nil;
    }
}

- (void)StartTimer{
    if (TimerMoving == FALSE) {
        TimerMoving = TRUE;
        self.tmrAnime = [NSTimer scheduledTimerWithTimeInterval:60.0f/(double)intSelectedTempo target:self selector:@selector(flashLabel) userInfo:nil repeats:YES];
    }
}

- (void)flashLabel{
    imgFlash.alpha = 1.0;
    [UIView animateWithDuration:0.1 animations:^{
        self->imgFlash.alpha = 0.0;

    } completion:^(BOOL finished) {
    }];

}

#pragma mark -
#pragma mark 次の曲へ
- (IBAction)goNextSong:(id)sender{
    if (intSelectedTableRowNo >= 0) {
        if (intSelectedTableRowNo < [arrSongs count] - 1) {
            intSelectedTableRowNo ++;
            [self selectedSongWithIndex:intSelectedTableRowNo];
        }else{
            intSelectedTempo = 0;
            [self selectedSongWithIndex:intSelectedTableRowNo];
        }
    }
}

@end
