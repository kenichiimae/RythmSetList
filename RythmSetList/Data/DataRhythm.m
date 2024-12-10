//
//  DataRhythm.m
//  RhythmKeeperiPad
//
//  Created by 今江 健一 on 2014/03/02.
//  Copyright (c) 2014年 今江 健一. All rights reserved.
//

#import "DataRhythm.h"
#import "AppDelegate.h"

static sqlite3_stmt *init_statement = nil;
static sqlite3_stmt *delete_statement = nil;

@implementation DataRhythm

+ (void)finalizeStatements {
    if (init_statement) {
        sqlite3_finalize(init_statement);
        init_statement = nil;
    }
    if (delete_statement) {
        sqlite3_finalize(delete_statement);
        delete_statement = nil;
    }
}

// Creates the object with primary key and title is brought into memory.
- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db withAllType:(NSInteger)allType{
    self = [super init];
    if (self) {
        primaryKey = pk;
        database = db;
        if (primaryKey==0) {
            switch (allType) {
                case 0:
                    self.strTitle=NSLocalizedString(@"all",@"");
                    break;
                case 1:
                    self.strTitle=NSLocalizedString(@"none",@"");
                    break;
                case 2:
                    self.strTitle=NSLocalizedString(@"selectone",@"");
                    break;
                default:
                    break;
            }
            self.intTempo=0;
        }else {
            // Compile the query for retrieving book data. See insertNewBookIntoDatabase: for more detail.
            if (init_statement == nil) {
                // Note the '?' at the end of the query. This is a parameter which can be replaced by a bound variable.
                // This is a great way to optimize because frequently used queries can be compiled once, then with each
                // use new variable values can be bound to placeholders.
                const char *sql;
                sql = "SELECT int_tempo, txt_Title, int_SortOrder FROM data_Rhythm WHERE int_RhythmID=?";
                if (sqlite3_prepare_v2(database, sql, -1, &init_statement, NULL) != SQLITE_OK) {
                    NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
                }
            }
            // For this query, we bind the primary key to the first (and only) placeholder in the statement.
            // Note that the parameters are numbered from 1, not from 0.
            sqlite3_bind_int(init_statement, 1, (int)primaryKey);
            if (sqlite3_step(init_statement) == SQLITE_ROW) {
                self.intTempo = sqlite3_column_int(init_statement, 0);
                self.strTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(init_statement, 1)];
                self.intSortOrder = sqlite3_column_int(init_statement, 2);
            } else {
                self.intTempo = 0;
                self.strTitle = @"";
            }
            // Reset the statement for future reuse.
            sqlite3_reset(init_statement);
        }
    }
    return self;
}

- (void)deleteFromDatabaseDatabase:(sqlite3 *)db{
    if (delete_statement == nil) {
        database = db;
        const char *sql = "DELETE FROM data_Rhythm WHERE int_RhythmID=?";
        if (sqlite3_prepare_v2(database, sql, -1, &delete_statement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
    // Bind the primary key variable.
    sqlite3_bind_int(delete_statement, 1, (int)primaryKey);
    // Execute the query.
    int success = sqlite3_step(delete_statement);
    // Reset the statement for future use.
    sqlite3_reset(delete_statement);
    // Handle errors.
    if (success != SQLITE_DONE) {
        NSAssert1(0, @"Error: failed to delete from database with message '%s'.", sqlite3_errmsg(database));
    }
}

#pragma mark -
#pragma mark リスト取得
- (NSMutableArray *)getSongList{
    AppDelegate *applicationDelegate;
    applicationDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSMutableArray *bookArray1 = [[NSMutableArray alloc] init];
    sqlite3 *database;
    if (sqlite3_open([applicationDelegate.dbpath UTF8String], &database) == SQLITE_OK) {
        // Get the primary key for all books.
        int primaryKey;
        const char *sql = "SELECT int_RhythmID FROM data_Rhythm ORDER BY int_SortOrder";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
        while (sqlite3_step(statement) == SQLITE_ROW) {
            primaryKey = sqlite3_column_int(statement, 0);
            DataRhythm *cDts = [[DataRhythm alloc] initWithPrimaryKey:primaryKey database:database withAllType:0];
            [bookArray1 addObject:cDts];
            [DataRhythm finalizeStatements];
        }
        // "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
    } else {
        // Even though the open failed, call close to properly clean up resources.
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
        // Additional error handling, as appropriate...
    }
    sqlite3_close(database);
    
    applicationDelegate = nil;

    return bookArray1;
}

- (void)addItemWithTempo:(int)intTempo andTitle:(NSString *)strTitle{
    AppDelegate *applicationDelegate;
    applicationDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    sqlite3 *database;
    sqlite3_stmt *statement = nil;
    if (sqlite3_open([applicationDelegate.dbpath UTF8String], &database) == SQLITE_OK) {
        const char *sql;
        char *sqlStr="";
        int maxID=0;
        sqlStr= "SELECT MAX(int_RhythmID) FROM data_Rhythm;";
        if(sqlite3_prepare_v2(database, sqlStr, -1, &statement, NULL) == SQLITE_OK) {
            int result = sqlite3_step(statement);
            if(result == SQLITE_ROW){
                maxID = sqlite3_column_int(statement, 0);
            }else{
                maxID = 0;
            }
        }
        maxID++;
        sqlite3_finalize(statement);
        int lastOrder=0;
        sqlStr= "SELECT MAX(int_SortOrder) FROM data_Rhythm;";
        if(sqlite3_prepare_v2(database, sqlStr, -1, &statement, NULL) == SQLITE_OK) {
            int result = sqlite3_step(statement);
            if(result == SQLITE_ROW){
                lastOrder = sqlite3_column_int(statement, 0);
            }else{
                lastOrder = 0;
            }
        }
        lastOrder++;
        sqlite3_finalize(statement);
        sql=[[NSString stringWithFormat: @"INSERT INTO data_Rhythm (int_RhythmID,txt_Title,int_SortOrder,int_tempo) VALUES (%d,'%@',%d, %d);",maxID,strTitle,lastOrder, intTempo] cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_exec( database, sql, 0, 0, NULL );
    }
    sqlite3_close( database );
    
    applicationDelegate = nil;

}

- (void)updateItemWithTempo:(int)intTempo andTitle:(NSString *)strTitle withItemID:(NSInteger)intEditingID{
    AppDelegate *applicationDelegate;
    applicationDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    sqlite3 *database;
    if (sqlite3_open([applicationDelegate.dbpath UTF8String], &database) == SQLITE_OK) {
        const char *sql;
        sql=[[NSString stringWithFormat: @"UPDATE data_Rhythm SET txt_Title = '%@', int_tempo = %d WHERE int_RhythmID = %ld;",strTitle, intTempo, intEditingID] cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_exec( database, sql, 0, 0, NULL );
    }
    sqlite3_close( database );
    
    applicationDelegate = nil;
}

- (NSInteger)primaryKey {
    return primaryKey;
}

- (NSInteger)intTempo {
    return intTempo;
}

- (void)setIntTempo:(NSInteger)aInt {
    if ((!intTempo && !aInt) || (intTempo == aInt)) return;
    intTempo = aInt;
}

- (NSInteger)intSortOrder {
    return intSortOrder;
}

- (void)setIntSortOrder:(NSInteger)aInt {
    if ((!intSortOrder && !aInt) || (intSortOrder == aInt)) return;
    intSortOrder = aInt;
}

- (NSString *)strTitle {
    return strTitle;
}

- (void)setStrTitle:(NSString *)aString {
    if ((!strTitle && !aString) || (strTitle && aString && [strTitle isEqualToString:aString])) return;
    strTitle = [aString copy];
}

@end
