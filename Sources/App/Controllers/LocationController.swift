//
//  PersonController.swift
//  
//
//  Created by Ruitong Su on 12/30/22.
//

import Fluent
import Vapor

struct LocationController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        // route /locations
        let locations = routes.grouped("locations")
        locations.get(use: index)
        locations.post(use: create)
        locations.put(use: update)
        locations.delete(use: delete)
        // route /location/:id
        locations.group(":id") { person in
            person.get(use: getByID)
            person.patch(use: updateByID)
            person.delete(use: deleteByID)
        }
    }

    // MARK: - /persons route

    // GET
    func index(req: Request) async throws -> [Location] {
        return try await Location.query(on: req.db).all()
    }

    // POST
    func create(req: Request) async throws -> Location {
        let location = try req.content.decode(Location.self)
        try await location.create(on: req.db)
        return location
    }

    // PUT
    func update(req: Request) async throws -> Location {
        let location = try req.content.decode(Location.self)

        guard let locationToUpdate = try await Location.find(location.id, on: req.db) else {
            throw Abort(.notFound)
        }

        locationToUpdate.label = location.label
        locationToUpdate.altitude = location.altitude
        locationToUpdate.longgitude = location.longgitude
        locationToUpdate.latitude = location.latitude

        try await locationToUpdate.save(on: req.db)
        return locationToUpdate
    }

    // DELETE
    func delete(req: Request) async throws -> HTTPStatus {
        let location = try req.content.decode(Location.self)

        guard let personToDelete = try await Location.find(location.id, on: req.db) else {
            throw Abort(.notFound)
        }

        try await personToDelete.delete(on: req.db)
        return .noContent
    }

    // MARK: - /persons/id route

    // GET
    func getByID(req: Request) async throws -> Location {
        guard let location = try await Location.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }

        return location
    }

    // PATCH
    func updateByID(req: Request) async throws -> Location {
        let patch = try req.content.decode(PatchLocation.self)

        guard let locationToUpdate = try await Location.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }

        if let newLabel = patch.label {
            locationToUpdate.label = newLabel
        }

        if let newLatitude = patch.latitude {
            locationToUpdate.latitude = newLatitude
        }

        if let newLonggitude = patch.longgitude {
            locationToUpdate.longgitude = newLonggitude
        }

        if let newAltitude = patch.altitude {
            locationToUpdate.altitude = newAltitude
        }

        try await locationToUpdate.save(on: req.db)
        return locationToUpdate
    }

    // DELETE
    func deleteByID(req: Request) async throws -> HTTPStatus {
        guard let locationToDelete = try await Location.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await locationToDelete.delete(on: req.db)
        return .noContent
    }
}
