//
//  DatabaseHelper.swift
//  openturnkey
//
//  Created by FuYuan Chuang on 2020/2/18.
//  Copyright © 2020 FuYuan Chuang. All rights reserved.
//

import SQLite3

class DatabaseHelper {
    var db:OpaquePointer? = nil
    let dbPath:String

    init?(path:String) {
        dbPath = path
        db = self.openDatabase(dbPath)
        if nil == db {
            return nil
        }
    }

    func openDatabase(_ path:String) -> OpaquePointer? {
        var dbTmp:OpaquePointer? = nil
        if SQLITE_OK == sqlite3_open(path, &dbTmp) {
            print("Open database successfully. \(path)")
            return dbTmp
        }
        else {
            print("Open database failed.")
            return nil
        }
    }

    func createTable(_ tableName:String, columns:[String]) -> Bool {
        let sql = "create table if not exists \(tableName) "
                + "(\(columns.joined(separator: ",")))"
        if SQLITE_OK == sqlite3_exec(self.db,
                                      sql.cString(using: String.Encoding.utf8),
                                      nil, nil, nil) {
            return true
        }
        return false

    }

    func insert(_ tableName :String, rowInfo :[String:String]) -> Bool {
        var statement :OpaquePointer? = nil
        let sql = "insert into \(tableName) "
            + "(\(rowInfo.keys.joined(separator: ","))) "
            + "values (\(rowInfo.values.joined(separator: ",")))"

        if SQLITE_OK == sqlite3_prepare_v2(self.db,
                                           sql.cString(using: String.Encoding.utf8),
                                           -1,
                                           &statement,
                                           nil) {
            if SQLITE_DONE == sqlite3_step(statement) {
                return true
            }
            sqlite3_finalize(statement)
        }
        
        return false
    }

    func update(_ tableName :String, cond :String?, rowInfo :[String:String]) -> Bool {
        var statement :OpaquePointer? = nil
        var sql = "update \(tableName) set "

        // row info
        var info :[String] = []
        for (k, v) in rowInfo {
            info.append("\(k) = \(v)")
        }
        sql += info.joined(separator: ",")

        // condition
        if let condition = cond {
            sql += " where \(condition)"
        }

        if SQLITE_OK == sqlite3_prepare_v2(self.db,
                                           sql.cString(using: String.Encoding.utf8),
                                           -1,
                                           &statement,
                                           nil) {
            if SQLITE_DONE == sqlite3_step(statement) {
                return true
            }
            sqlite3_finalize(statement)
        }
        
        return false
        
    }

    func fetch(_ tableName :String, cond :String?, order :String?) -> OpaquePointer {
        var statement :OpaquePointer? = nil
        var sql = "select * from \(tableName)"
        if let condition = cond {
            sql += " where \(condition)"
        }
        
        if let orderBy = order {
            sql += " order by \(orderBy)"
        }
        
        sqlite3_prepare_v2(self.db, sql.cString(using: String.Encoding.utf8), -1, &statement, nil)
        
        return statement!
    }

    func delete(_ tableName :String, cond :String?) -> Bool {
        var statement :OpaquePointer? = nil
        var sql = "delete from \(tableName)"

        if let condition = cond {
            sql += " where \(condition)"
        }

        if SQLITE_OK == sqlite3_prepare_v2(self.db,
                                           sql.cString(using: String.Encoding.utf8),
                                           -1,
                                           &statement,
                                           nil) {
            if sqlite3_step(statement) == SQLITE_DONE {
                return true
            }
            sqlite3_finalize(statement)
        }

        return false
    }
}
