//
//  NSString+SqlAddition.m
//  LFFMDB
//
//  Created by wen on 2017/3/27.
//  Copyright © 2017年 LuoFengcompany. All rights reserved.
//

#import "NSString+SqlAddition.h"

@implementation NSString (SqlAddition)

- (NSString *)makeSQL:(void (^)(SQLTool *))block{
    
    SQLTool *sqlTool = [[SQLTool alloc] initWithDBName:self];
    block(sqlTool);
    
    return nil;
}


@end
