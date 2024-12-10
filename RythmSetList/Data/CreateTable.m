//
//  CreateTable.m
//  PawPaw
//
//  Created by 今江 健一 on 2021/07/04.
//  Copyright © 2021 今江 健一. All rights reserved.
//

#import "CreateTable.h"
#import <sqlite3.h>

@implementation CreateTable
#pragma mark -
#pragma mark DBテーブル作成
// Creates a writable copy of the bundled default database in the application Documents directory.
- (NSString *)createEditableCopyOfDatabaseIfNeeded {
    sqlite3 *database;
    BOOL success;
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasepath = [documentsDirectory stringByAppendingPathComponent:@"MemRec.db"];
    
    NSString *dbpath = [[NSString alloc] initWithString:databasepath];
    success = [[NSFileManager defaultManager] fileExistsAtPath:dbpath];
    if(!success){
        //データベースがない場合はオープン関数によってDBを作成
        int rc = sqlite3_open( [dbpath UTF8String], &database );
        if ( rc != SQLITE_OK ) {
            //NSLog(@"DB作成失敗");
        }else{
            sqlite3_close(database);
        }
    }
    
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_open([dbpath UTF8String], &database) == SQLITE_OK) {
        const char *sql;
        char *zErrMsg;
        /*
         sql = "DROP TABLE mst_Brand";
         sqlite3_exec( database, sql, 0, 0, NULL );
         //*/
        
        sqlite3_exec( database, "PRAGMA auto_vacuum=1", NULL, NULL, NULL );
        
        sql = "select * from data_Rhythm";
        //char *zErrMsg;
        if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
            // テーブルの作成
            char Table_Create_SQL[] = "    CREATE TABLE data_Rhythm ("
            "    int_RhythmID INTEGER IDENTITY (1, 1) NOT NULL"
            "    , int_tempo INTEGER NOT NULL DEFAULT 80"
            "    , txt_Title TEXT NOT NULL DEFAULT ''"
            "    , int_SortOrder INTEGER NOT NULL DEFAULT 0"
            "    , PRIMARY KEY (int_RhythmID)"
            "    );"
            ;
            sqlite3_exec( database, Table_Create_SQL, 0, 0, NULL );
        }
        sqlite3_finalize(statement);

    }
    sqlite3_close( database );
    
    return dbpath;
}

@end
