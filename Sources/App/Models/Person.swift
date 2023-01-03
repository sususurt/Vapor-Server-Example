//
//  Person.swift
//  
//
//  Created by Ruitong Su on 12/30/22.
//

import Fluent
import Vapor

final class Person: Model, Content {
    static let schema = "persons"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    init() { }

    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

// MARK: - Structure of PATCH /persons/:id request
struct PatchPerson: Decodable {
    var name: String?
}
