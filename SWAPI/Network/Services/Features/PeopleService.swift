//
//  PeopleService.swift
//  SWAPI
//
//  Created by Jaime Escobar on 19/02/24.
//

import Foundation

protocol PeopleService: NetworkService {
    func getAll(page: Int) async throws -> [People]
    func getBy(ids: [Int]) async throws -> [People]
    func getBy(id: Int) async throws -> People
}

protocol PeopleDetailsService {
    func getDetails(for people: People) async throws -> PeopleDetails
}

final class LivePeopleService: PeopleService {
    func getBy(ids: [Int]) async throws -> [People] {
        try await withThrowingTaskGroup(
            of: People.self,
            returning: [People].self
        ) { group in
            ids.forEach { id in
                group.addTask {
                    try await self.getBy(id: id)
                }
            }
            var people = [People]()
            while let person = try await group.next() {
                people.append(person)
            }
            return people
        }
    }
    
    func getAll(page: Int) async throws -> [People] {
        let response: Response<People> = try await SWAPI.load(
            router: PeopleRouter.getAll(page: page)
        )
        return response.results
    }

    func getBy(id: Int) async throws -> People {
        try await SWAPI.load(
            router: PeopleRouter.getDetails(id: id)
        )
    }
}

final class MockPeopleService: PeopleService {
    func getAll(page: Int) async throws -> [People] {
        [.demo]
    }

    func getBy(ids: [Int]) async throws -> [People] {
        [.demo]
    }

    func getBy(id: Int) async throws -> People {
        .demo
    }
}

final class MockPeopleDetailsService: PeopleDetailsService {
    func getDetails(for people: People) async throws -> PeopleDetails {
        .demo
    }
}
