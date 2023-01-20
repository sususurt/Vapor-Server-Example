//
//  Person.swift
//  
//
//  Created by Ruitong Su on 12/30/22.
//

import Fluent
import Vapor

final class Location: Model, Content {
    static let schema = "locations"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "label")
    var label: String

    @Field(key: "timestamp")
    var timestamp: TimeInterval

    @Field(key: "latitude")
    var latitude: String

    @Field(key: "longgitude")
    var longgitude: String

    @Field(key: "altitude")
    var altitude: String

    init() { }

    init(id: UUID? = nil, label: String, latitude: String, longgitude: String, altitude: String) {
        self.id = id
        self.label = label
        self.latitude = latitude
        self.longgitude = longgitude
        self.altitude = altitude
    }
}

// MARK: - Structure of PATCH /persons/:id request
struct PatchLocation: Decodable {
    var label: String?
    var timestamp: TimeInterval?
    /// DATA
    let latitude: String?
    let longgitude: String?
    let altitude: String?
}
