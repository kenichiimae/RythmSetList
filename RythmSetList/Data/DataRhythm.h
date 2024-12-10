//
//  DataRhythm.h
//  RhythmKeeperiPad
//
//  Created by 今江 健一 on 2014/03/02.
//  Copyright (c) 2014年 今江 健一. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DataRhythm : NSObject{
    sqlite3 *database;
    NSInteger primaryKey;
    // Attributes.
    NSInteger intTempo;
    NSString *strTitle;
    NSInteger intSortOrder;
}
@property (assign, nonatomic, readonly) NSInteger primaryKey;
// The remaining attributes are copied rather than retained because they are value objects.
@property (nonatomic) NSInteger intTempo;
@property (copy, nonatomic) NSString *strTitle;
@property (nonatomic) NSInteger intSortOrder;

+ (void)finalizeStatements;

// Creates the object with primary key and title is brought into memory.
- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db withAllType:(NSInteger)allType;

- (void)deleteFromDatabaseDatabase:(sqlite3 *)db;
@end
