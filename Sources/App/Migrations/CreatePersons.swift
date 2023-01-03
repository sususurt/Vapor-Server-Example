//
//  CreatePersons.swift
//  
//
//  Created by Ruitong Su on 12/30/22.
//

import Fluent

struct CreatePersons: AsyncMigration {
    // 为存储 Person 模型准备数据库。
    func prepare(on database: Database) async throws {
        try await database.schema("persons")
            .id()
            .field("name", .string, .required)
            .create()
    }

    // 可选地恢复 prepare 方法中所做的更改。
    func revert(on database: Database) async throws {
        try await database.schema("persons").delete()
    }


}
