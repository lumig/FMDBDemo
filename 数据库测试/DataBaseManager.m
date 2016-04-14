//
//  DataBaseManager.m
//  数据库测试
//
//  Created by chuxiaolong on 15/1/16.
//  Copyright (c) 2015年 chuxiaolong. All rights reserved.
//

#import "DataBaseManager.h"
static DataBaseManager *shareManager = nil;
@implementation DataBaseManager
+(DataBaseManager *)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        shareManager = [[self alloc] init];
        [shareManager createEditableCopyOfDatabaseIfNeeded];
        
        
    });
    return shareManager;
}
//设置数据库的保存文件
- (NSString *)applicationDocumentsDirectoryFile {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:dbName];
    return path;
}
//创建数据库以及创建表
- (void)createEditableCopyOfDatabaseIfNeeded
{
    NSString *writableDBPath = [self applicationDocumentsDirectoryFile];
    db = [FMDatabase databaseWithPath:writableDBPath];//不存在，则自动创建
    if (![db open]) {
        NSLog(@"Could not open db");
        return;
    }
    //定义创建用户表的SQL语句
    NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@  (id INTEGER PRIMARY KEY AUTOINCREMENT, student_id INTEGER, student_class INTEGER, student_name  VARCHAR, student_age INTEGER);",TABLE_USER];
    if ([db executeUpdate:createSQL] == NO) {
        NSLog(@"创建用户表失败");
        [db close];
        return;
    }

}

//若版本号发生变化就删除掉先前的表
-(void)onUpgrade:(FMDatabase*)dataBase  oldVersion:(int)oldversion newVersion:(int)newversion
{
//    if ([db open]) {
//        [db beginTransaction];
//        [db executeUpdate:[NSString stringWithFormat:@"DROP TABLE IF EXISTS %@",TABLE_USER]];
//        [db executeUpdate:[NSString stringWithFormat:@"DROP TABLE IF EXISTS %@",MEDICREMINDER]];
//        [db executeUpdate:[NSString stringWithFormat:@"DROP TABLE IF EXISTS %@",TABEL_GOODS_CATEGORY]];
//        [db commit];
//        [db close];
//    }
//    [self createEditableCopyOfDatabaseIfNeeded];
}

//查询数据 //直接返回游标，在函数调用的地方
-(FMResultSet *)userQueryData:(NSString *)inquerySql objects:(NSArray *)objects
{
    if (inquerySql == nil) {
        return nil;
    }
    FMResultSet *rs = nil;
    if ([db open]) {
        
        if (objects == nil) {
            rs = [db executeQuery:inquerySql];
        }
        else
        {
            rs = [db executeQuery:inquerySql withArgumentsInArray:objects];
        }
        return rs;
    }
    return nil;
}

//数据插入,删除
-(void)insertOrDeleteData:(NSString *)sql objects:(NSArray*)objects
{
    if ([db open]) {
        if (sql == nil) {
            return;
        }
        [db beginTransaction];
        if (objects == nil) {
            [db executeUpdate:sql];
        }
        else
        {
            [db executeUpdate:sql withArgumentsInArray:objects];
        }
        [db commit];
        [db close];
    }
}

//数据删除(整个表)
-(void)deleteSheet:(NSString *)deleteSql
{
    if ([db open]) {
        [db beginTransaction];
        [db executeUpdate:deleteSql];
        [db commit];
        [db close];
    }
}
//分割数据库中的字符串结构
-(NSMutableArray *)trimStringFromDataBase:(NSString*)strDataBase
{
    NSString *strFirst = nil;
    NSMutableArray *returnArray = [NSMutableArray array];
    
    NSArray *array = [strDataBase componentsSeparatedByString:@"\n"];  //与换行符来分割
    //去除第一个和最后一个因为这两个是左右括号,array中的数据作为NSString数组
    for (int i = 1; i < [array count] - 1; i++) {
        
        strFirst = (NSString *)array[i];
        NSString *strSecond =  [strFirst stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (i != [array count] - 2)
        {
            //数据库中的数据返回有逗号为分隔符
            if ([strSecond hasSuffix:@","]) {
                NSString *strThird = [strSecond substringToIndex:[strSecond length] - 1];
                [returnArray addObject:strThird];
            }
            
        }
        else
        {
            [returnArray addObject:strSecond];
        }
    }
    return returnArray;
}
@end
