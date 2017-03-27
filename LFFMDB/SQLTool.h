//
//  SQLTool.h
//  FunctionalProgramming
//
//  Created by wen on 2017/3/27.
//  Copyright © 2017年 KLDF. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SQLTool;


@interface SQLTool : NSObject

@property (nonatomic ,strong) NSString *haha;

//custom method
//+ (NSString *)makeSQL:(void (^)(SQLTool *tool))block;

//Create DB
- (instancetype)initWithDBName:(NSString *)DBName;


//Create
typedef SQLTool *(^Create)(NSString *form);
@property (nonatomic ,strong,readonly) Create create;

//AddProperty
typedef SQLTool *(^AddProperty)(NSDictionary *propertyDict);
@property (nonatomic ,strong,readonly) AddProperty addProperty;

//insert
typedef SQLTool *(^Insert)(NSObject *obj);
@property (nonatomic ,strong,readonly) Insert insert;
//key
//typedef SQLTool *(^Key)(NSArray<NSString *> *key);
//@property (nonatomic ,strong,readonly) Key key;
////value
//typedef SQLTool *(^Value)(NSArray<NSString *> *value);
//@property (nonatomic ,strong,readonly) Value value;


//Delete
typedef SQLTool *(^Delete)(NSString *form);
@property (nonatomic ,strong,readonly) Delete sqlDelete;
//Where
typedef SQLTool *(^Where)(NSDictionary *whereDict);
@property (nonatomic ,strong,readonly) Where where;//WHERE name = 'Tom-4'    WHERE age > 20


//Update
typedef SQLTool *(^Update)(NSString *form);
@property (nonatomic ,strong,readonly) Update update;
//Set
typedef SQLTool *(^Set)(NSString *sqlSet);//SET age = '101'
@property (nonatomic ,strong,readonly) Set set;


//select
typedef SQLTool *(^Select)(NSArray<NSString *> *columns);
@property (nonatomic ,strong,readonly) Select select;

//And
typedef SQLTool *(^And)(NSString *sqlAnd);
@property (nonatomic ,strong,readonly) And sqlAnd;


@property (nonatomic ,strong,readonly) NSString *execute;//执行语句


@end
