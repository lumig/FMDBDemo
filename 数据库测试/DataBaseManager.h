//
//  DataBaseManager.h
//  数据库测试
//
//  Created by chuxiaolong on 15/1/16.
//  Copyright (c) 2015年 chuxiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"


#define dbName          @"user_manager"  //数据库名字,和andior取名一样
#define TABLE_USER      @"student"

//=============学生=====================




@interface DataBaseManager : NSObject


{
    FMDatabase *db;
    
}
+(DataBaseManager *)sharedManager;
- (void)createEditableCopyOfDatabaseIfNeeded;
-(void)onUpgrade:(FMDatabase*)dataBase  oldVersion:(int)oldversion newVersion:(int)newversion;
-(FMResultSet *)userQueryData:(NSString *)inquerySql objects:(NSArray *)objects;
-(void)insertOrDeleteData:(NSString *)sql objects:(NSArray*)objects;
-(void)deleteSheet:(NSString *)deleteSql;
-(NSMutableArray *)trimStringFromDataBase:(NSString*)strDataBase;

@end
