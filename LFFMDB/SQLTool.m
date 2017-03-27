//
//  SQLTool.m
//  FunctionalProgramming
//
//  Created by wen on 2017/3/27.
//  Copyright © 2017年 KLDF. All rights reserved.
//

#import "SQLTool.h"
#import <FMDB.h>
#import "NSObject+GetProperties.h"

@interface SQLTool ()

@property (nonatomic ,strong) NSString *sql;

@property (nonatomic ,strong) NSString *DBName;
@property (nonatomic ,strong) FMDatabase *db;

@end

@implementation SQLTool

- (instancetype)initWithDBName:(NSString *)DBName{
    
    self = [super init];
    if (!self) return nil;
    
    self.DBName = DBName;
    
    //1、 Create Database With Path
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:DBName];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    self.db = db;
    
    //2、 Open DB
//    if (![self.db open]) {
//        self.db = nil;
//        NSLog(@"FMDatabase can't open !");
//    } else {
//        NSLog(@"FMDatabase open success !");
//        //3、 Create TABLE
//        BOOL result = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age text NOT NULL);"];
//        if (result) {
//            NSLog(@"Create table success !");
//        } else {
//            NSLog(@"Create table faile !");
//        }
//    }
    
    return self;
}


//+(NSString *)makeSQL:(void (^)(SQLTool *))block{
//    SQLTool *tool = [[SQLTool alloc] init];
//    block(tool);
//    return @"";
//}

- (Create)create{
    return ^(NSString *form){
        //2、 Open DB
        if ([self.db open]) {
           self.sql = [self.sql stringByAppendingString: [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ",form]];
        } else {
            self.db = nil;
            NSLog(@"FMDatabase can't open !");
        }
        
        return self;
    };
}


//(id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age text NOT NULL);
//@{name:text,age:text}
//@{属性名：类型}
- (AddProperty)addProperty{
    return ^(NSDictionary *propertyDict){
        if (propertyDict.count == 0) {
            return self;
        }
        NSString *string = @"(id integer PRIMARY KEY AUTOINCREMENT";
        NSArray *keys = [propertyDict allKeys];
        for (NSString *key in keys) {
            string = [string stringByAppendingString:@","];
            string = [string stringByAppendingString:key];
            string = [string stringByAppendingString:@" "];
            string = [string stringByAppendingString:propertyDict[key]];
        }
        string = [string stringByAppendingString:@");"];
        self.sql = [self.sql stringByAppendingString:string];
        
        //3、 Create TABLE
        BOOL result = [self.db executeUpdate:self.sql];
        if (result) {
            NSLog(@"Create table success !");
        } else {
            NSLog(@"Create table faile !");
        }
        
        
        return self;
    };
}

//string = [string stringByAppendingString:@""];
-(Insert)insert{
    return ^(NSObject *obj){
        NSString *insertString = [NSString stringWithFormat:@"INSERT INTO %@",self.DBName];
        insertString = [insertString stringByAppendingString:@" ("];
        
        NSArray <NSString *>*propertyArray = [[obj class] getProperties];
        if (propertyArray.count == 0) {
            NSLog(@"插入属性为空");
            return self;
        }
        
        //先插入一条，然后后面的数据以更新的形式插入
        insertString = [insertString stringByAppendingString:[NSString stringWithFormat:@"%@)",propertyArray[0]]];
        insertString = [insertString stringByAppendingString:@"VALUES (?);"];
        [self.db executeUpdate:insertString,[obj valueForKey:propertyArray[0]]];
        
        //插入一条后获取主键，便后续更新插入
        FMResultSet *resultSet = [self.db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",self.DBName]];
        NSString *mainKey;
        while ([resultSet next]) {
            mainKey = [resultSet stringForColumn:@"id"];
            NSLog(@"主键id -- %@",[resultSet stringForColumn:@"id"]);
        }
        if (!mainKey) {
            NSLog(@"获取主键失败");
            return self;
        }
        
        if (propertyArray.count <= 1) {
            return self;
        }
        
        
        //后续更新插入
        for (int i = 1; i < propertyArray.count; i++) {
            
            NSString *updateString = [NSString stringWithFormat:@"UPDATE %@ ",self.DBName];
            updateString = [updateString stringByAppendingString:[NSString stringWithFormat:@"SET %@ = (?) WHERE id = %@",propertyArray[i],mainKey]];
            [self.db executeUpdate:updateString,[obj valueForKey:propertyArray[i]]];
        }
        
        
        return self;
    };
}

-(Delete)sqlDelete{
    return ^(NSString *form){
        self.sql = @"";
        self.sql = [NSString stringWithFormat:@"DELETE FROM %@ ",self.DBName];
        
        return self;
    };
}

- (Where)where{
    return ^(NSDictionary *whereDict){
        NSString *key = [[whereDict allKeys] firstObject];
        id object = [whereDict valueForKey:key];
        self.sql = [self.sql stringByAppendingString:[NSString stringWithFormat:@"WHERE %@ = '%@'",key,object]];
        
        return self;
    };
}

-(NSString *)execute{
    [self.db open];
    [self.db executeUpdate:self.sql];
    [self.db close];
    return nil;
}

@end
