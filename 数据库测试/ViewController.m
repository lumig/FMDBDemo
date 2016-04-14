//
//  ViewController.m
//  数据库测试
//
//  Created by chuxiaolong on 15/1/16.
//  Copyright (c) 2015年 chuxiaolong. All rights reserved.
//

#import "ViewController.h"
#import "DataBaseManager.h"




NSString * INSERT_USER_SQL = @"INSERT INTO student (student_id, student_class, student_name, student_age) values (?, ?, ?, ?)";//插入数据
NSString * SELECT_USER_SQL = @"SELECT * FROM student where student_name = ?";//根据学生名字查询
NSString * DELETE_USER_SQL = @"DELETE FROM student where student_name = ?";//根据学生名字删除
NSString * SELECT_USERS_SQL = @"SELECT * FROM student";//查询所有的学生
NSString * DELETE_All_SQL = @"DELETE FROM student";//全部删除
NSString * DELETE_One_SQL = @"DELETE FROM student where student_name = ?";//删除一个
//更新学生的年龄 根据学生的名字
NSString * UPDATE_STUDENT_WITH_Name = @"UPDATE student set student_age = ? where student_name = ?";



//以下是对于本工程没有用的，只是可以参考可以根据几个参数来查询然后修改数据 
//以下几种都是update方法（此工程没用上 可以作为参考）
NSString * UPDATE_HOME_WITH_READ = @"UPDATE home set is_read = ? where id = ?";
NSString * UPDATE_HOME_ISREAD_SQL = @"UPDATE home set is_read = ?  where homesession_id = ? and homesession_type = ? ";
NSString * UPDATE_HOME_ISREAD_TYPE_SQL = @"UPDATE home set is_read = ? ,homesession_type = ?  where homesession_id = ? and homesession_type = ? ";
NSString * UPDATE_HOME_ISREAD_BY_TYPE_USERID = @"UPDATE home set is_read = ?   where  homesession_type = ? and user_id = ?";


@implementation Student



@end





@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"存放地址是%@",NSHomeDirectory());
}


-(IBAction)addStudent:(id)sender
{
    [[DataBaseManager sharedManager] insertOrDeleteData:INSERT_USER_SQL objects:@[[NSNumber numberWithInt:1],[NSNumber numberWithInt:3],@"小王",[NSNumber numberWithInt:25]]];
    [[DataBaseManager sharedManager] insertOrDeleteData:INSERT_USER_SQL objects:@[[NSNumber numberWithInt:2],[NSNumber numberWithInt:4],@"周灵龙",[NSNumber numberWithInt:22]]];
    [[DataBaseManager sharedManager] insertOrDeleteData:INSERT_USER_SQL objects:@[[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],@"张佳仁",[NSNumber numberWithInt:35]]];
    [[DataBaseManager sharedManager] insertOrDeleteData:INSERT_USER_SQL objects:@[[NSNumber numberWithInt:4],[NSNumber numberWithInt:3],@"micile",[NSNumber numberWithInt:33]]];
    [[DataBaseManager sharedManager] insertOrDeleteData:INSERT_USER_SQL objects:@[[NSNumber numberWithInt:5],[NSNumber numberWithInt:2],@"无锡",[NSNumber numberWithInt:21]]];
    
}
-(IBAction)deleteStudent:(id)sender
{
    //删除一个
     [[DataBaseManager sharedManager] insertOrDeleteData:DELETE_One_SQL objects:@[@"小王"]];
}

-(IBAction)updateStudent:(id)sender
{
    //根据周灵龙的名字 修改年龄为97
    [[DataBaseManager sharedManager] insertOrDeleteData:UPDATE_STUDENT_WITH_Name objects:@[[ NSNumber numberWithInt:97],@"周灵龙"]];
}
//查询
-(IBAction)selectedStudent:(id)sender
{
    //可以根据名字查找 或者直接查找全部的
    //如果要根据名字或者学号查找 传入数据库语句@"SELECT * FROM student where student_name = ?" 然后数组中传学生的名字
    FMResultSet *resultSet = [[DataBaseManager sharedManager] userQueryData:SELECT_USERS_SQL objects:nil];
    while ([resultSet next])
    {
        Student *stu = [[Student alloc] init];
        stu.name = [resultSet stringForColumn:@"student_name"];
        stu.age = [resultSet intForColumn:@"student_age"];
        NSLog(@"学生姓名是:%@",stu.name);
        //以下可以把stu这个对象装到数组里，我不高兴操作
    }
}

-(IBAction)deleteAllStudent:(id)sender
{
    //全部删除，用这个方法是可以的 但是不知道用-(void)deleteSheet:(NSString *)deleteSql 是什么情况 是把整个表都删除？
    [[DataBaseManager sharedManager] insertOrDeleteData:DELETE_All_SQL objects:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
