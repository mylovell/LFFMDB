//
//  ViewController.m
//  LFFMDB
//
//  Created by LuoFeng on 2017/1/11.
//  Copyright © 2017年 LuoFengcompany. All rights reserved.
//

#import "ViewController.h"
#import <FMDB.h>

@interface ViewController ()

@property (nonatomic ,strong) FMDatabase *db;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dict = [NSDictionary dictionary];
    [dict allKeys];
    
    //1、 Create Database With Path
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"t_student.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    self.db = db;
    
    //2、 Open DB
    if (![self.db open]) {
        self.db = nil;
        NSLog(@"FMDatabase can't open !");
    } else {
        NSLog(@"FMDatabase open success !");
        //3、 Create TABLE
        BOOL result = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age text NOT NULL);"];
        if (result) {
            NSLog(@"Create table success !");
        } else {
            NSLog(@"Create table faile !");
        }
    }
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}



- (IBAction)add:(id)sender {
    
    [self.db open];
    for (int i = 0; i < 10; i++) {
        NSString *name = [NSString stringWithFormat:@"Tom-%i",i];
        NSString *age = [NSString stringWithFormat:@"%i",15 + i];
        [self.db executeUpdate:@"INSERT INTO t_student (name, age) VALUES (?, ?);",name,age];
        NSLog(@"add:%@--%@",name,age);
    }
    [self.db close];
    
    
}

- (IBAction)delete:(id)sender {
    
    [self.db open];
    [self.db executeUpdate:@"DELETE FROM t_student WHERE name = 'Tom-3'"];
    [self.db close];
}

- (IBAction)update:(id)sender {
    [self.db open];
    //[self.db executeUpdate:@"UPDATE t_student SET age = '101' WHERE name = 'Tom-4'"];
    [self.db executeUpdate:@"UPDATE t_student SET age = (?) WHERE name = 'Tom-4'",@1010];
    [self.db close];
    
}

//SELECT name, age, score FROM t_student;
- (IBAction)query:(id)sender {
    [self.db open];
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_student WHERE age > 20;"];
    
    while ([resultSet next]) {
        NSLog(@"name -- %@",[resultSet stringForColumn:@"name"]);
        NSLog(@"age -- %@",[resultSet stringForColumn:@"age"]);
    }
    [self.db close];
    
    
}



@end
