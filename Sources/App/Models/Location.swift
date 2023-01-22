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

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Field(key: "label")
    var label: String

    @Field(key: "latitude")
    var latitude: String

    @Field(key: "longitude")
    var longitude: String

    @Field(key: "altitude")
    var altitude: String

    init() { }

    init(id: UUID? = nil, label: String, latitude: String, longitude: String, altitude: String) {
        self.id = id
        self.label = label
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
    }
}

// MARK: - Structure of PATCH /persons/:id request
struct PatchLocation: Decodable {
    var label: String?
    var timestamp: TimeInterval?
    /// DATA
    let latitude: String?
    let longitude: String?
    let altitude: String?
}
