//
//  PersonController.swift
//  
//
//  Created by Ruitong Su on 12/30/22.
//

import Fluent
import Vapor

struct PersonController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        // route /persons
        let persons = routes.grouped("persons")
        persons.get(use: index)
        persons.post(use: create)
        persons.put(use: update)
        persons.delete(use: delete)
        // route /persons/:id
        persons.group(":id") { person in
            person.get(use: getByID)
            person.patch(use: updateByID)
            person.delete(use: deleteByID)
        }
    }

    // MARK: - /persons route

    // GET
    func index(req: Request) async throws -> [Person] {
        return try await Person.query(on: req.db).all()
    }

    // POST
    func create(req: Request) async throws -> Person {
        let person = try req.content.decode(Person.self)
        try await person.create(on: req.db)
        return person
    }

    // PUT
    func update(req: Request) async throws -> Person {
        let person = try req.content.decode(Person.self)

        guard let personToUpdate = try await Person.find(person.id, on: req.db) else {
            throw Abort(.notFound)
        }

        personToUpdate.name = person.name

        try await personToUpdate.save(on: req.db)
        return personToUpdate
    }

    // DELETE
    func delete(req: Request) async throws -> HTTPStatus {
        let person = try req.content.decode(Person.self)

        guard let personToDelete = try await Person.find(person.id, on: req.db) else {
            throw Abort(.notFound)
        }

        try await personToDelete.delete(on: req.db)
        return .noContent
    }

    // MARK: - /persons/id route

    // GET
    func getByID(req: Request) async throws -> Person {
        guard let person = try await Person.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }

        return person
    }

    // PATCH
    func updateByID(req: Request) async throws -> Person {
        let patch = try req.content.decode(PatchPerson.self)

        guard let personToUpdate = try await Person.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }

        if let newName = patch.name {
            personToUpdate.name = newName
        }

        try await personToUpdate.save(on: req.db)
        return personToUpdate
    }

    // DELETE
    func deleteByID(req: Request) async throws -> HTTPStatus {
        guard let personToDelete = try await Person.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await personToDelete.delete(on: req.db)
        return .noContent
    }
}
