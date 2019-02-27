//
//  GYFMDB.h
//  ExTensionDemo
//
//  Created by lyons on 2019/2/26.
//  Copyright © 2019 lyons. All rights reserved.
//

#ifndef GYFMDB_h
#define GYFMDB_h

#define GYDB_DEFAULT_NAME @"GYTodo"
#define GYFMDBMANAGER [GYFMDBManager shareManager:FLDB_DEFAULT_NAME]
#define GYFMDBMANAGERX(DB_NAME) [GYFMDBManager shareManager:DB_NAME]
/**
 初始化一个在 app group 中创建的表
 */
#define GYFMDBMANAGERG(DB_NAME) [GYFMDBManager shareManagerWithGroupFileName:DB_NAME]

#import "GYFMDBManager.h"

#endif /* GYFMDB_h */
