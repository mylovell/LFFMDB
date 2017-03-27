//
//  NSString+SqlAddition.h
//  LFFMDB
//
//  Created by wen on 2017/3/27.
//  Copyright © 2017年 LuoFengcompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLTool.h"

@interface NSString (SqlAddition)

- (NSString *)makeSQL:(void (^)(SQLTool *tool))block;

@end
