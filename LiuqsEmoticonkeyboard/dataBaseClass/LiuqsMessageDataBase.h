//
//  LiuqsDataBaseManager.h
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2017/1/5.
//  Copyright © 2017年 刘全水. All rights reserved.

//

#import <Foundation/Foundation.h>

@interface LiuqsMessageDataBase : NSObject

/*
 * 插入数据，已经存在的不会再次插入
 */
+ (BOOL)insertMessageWithSql:(NSString *)Sql;
/*
 * 查询数据，默认全部查询出来
 */
+ (NSMutableArray *)queryData:(NSString *)querySql;
/*
 * 删除数据，默认删除所有
 */
+ (BOOL)deleteData:(NSString *)deleteSql;


@end
;
