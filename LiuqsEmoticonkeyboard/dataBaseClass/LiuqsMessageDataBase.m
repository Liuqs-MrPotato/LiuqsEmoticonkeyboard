//
//  LiuqsDataBaseManager.m
//  LiuqsEmoticonkeyboard
//
//  Created by 刘全水 on 2017/1/5.
//  Copyright © 2017年 刘全水. All rights reserved.
//

#import "LiuqsMessageDataBase.h"
#import "ChatMessage.h"

static FMDatabaseQueue *dataBaseQueue;

@implementation LiuqsMessageDataBase

+ (void)initialize {

    dataBaseQueue = [FMDatabaseQueue databaseQueueWithPath:[LiuqsFileManager getDBPath]];
    [dataBaseQueue inDatabase:^(FMDatabase *db) {
        //创建表
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(userId INTEGER PRIMARY KEY, userName TEXT NOT NULL, userHeadImage TEXT NOT NULL, messageContent TEXT NOT NULL, userType INTEGER NOT NULL);",tb_message];
        BOOL createTableResult = [db executeUpdate:sql];
        if (createTableResult) {
            NSLog(@"创建消息表成功");
        }else{
            NSLog(@"创建消息表失败");
        }
    }];
}

+ (BOOL)insertMessageWithSql:(NSString *)Sql {

     BOOL __block result;
    [dataBaseQueue inDatabase:^(FMDatabase *db) {
        
        result = [db executeUpdate:Sql];
        if (result) {
            NSLog(@"插入成功！");
        }else {
            NSLog(@"插入失败");
        }
    }];
    return result;
}


+ (BOOL)deleteData:(NSString *)deleteSql {
    
    if (deleteSql == nil) {
        deleteSql = [NSString stringWithFormat:@"DELETE FROM %@",tb_message];
    }
    BOOL __block result;
    [dataBaseQueue inDatabase:^(FMDatabase *db) {
        
        result = [db executeUpdate:deleteSql];
        if (result) {
            NSLog(@"删除成功！");
        }else {
            NSLog(@"删除失败");
        }
    }];
    
    return result;
}

+ (NSMutableArray *)queryData:(NSString *)querySql {
    
    if (querySql == nil) {
        querySql = [NSString stringWithFormat:@"SELECT * FROM %@;",tb_message];
    }
    NSMutableArray *arrM = [NSMutableArray array];
    [dataBaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:querySql];
        while ([set next]) {
            ChatMessage *message = [[ChatMessage alloc]init];
            message.userName = [set stringForColumn:@"userName"];
            message.userHeadImage = [set stringForColumn:@"userHeadImage"];
            message.userType = [set intForColumn:@"userType"];
            message.messageContent = [set stringForColumn:@"messageContent"];
            message.userId = [set intForColumn:@"userId"];
            [arrM addObject:message];
        }
    }];
    return arrM;
}



@end
