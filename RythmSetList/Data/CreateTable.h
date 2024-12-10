//
//  CreateTable.h
//  PawPaw
//
//  Created by 今江 健一 on 2021/07/04.
//  Copyright © 2021 今江 健一. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreateTable : NSObject

- (NSString *)createEditableCopyOfDatabaseIfNeeded;

@end

NS_ASSUME_NONNULL_END
