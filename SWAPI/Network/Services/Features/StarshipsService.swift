//
//  StarshipsService.swift
//  SWAPI
//
//  Created by Jaime Escobar on 19/02/24.
//

import Foundation

protocol StarshipsService: NetworkService {
    func getAll(page: Int) async throws -> [Starship]
    func getBy(id: Int) async throws -> Starship
    func getBy(ids: [Int]) async throws -> [Starship]
}

protocol StarshipDetailsService {
    func getDetails(for starship: Starship) async throws -> StarshipDetails
}

final class LiveStarshipsService: StarshipsService {
    func getAll(page: Int) async throws -> [Starship] {
        let response: Response<Starship> = try await SWAPI.load(
            router: StarshipsRouter.getAll(page: page)
        )
        return response.results
    }

    func getBy(ids: [Int]) async throws -> [Starship] {
        try await withThrowingTaskGroup(
            of: Starship.self,
            returning: [Starship].self
        ) { group in
            ids.forEach { id in
                group.addTask {
                    try await self.getBy(id: id)
                }
            }
            var starships = [Starship]()
            while let starship = try await group.next() {
                starships.append(starship)
            }
            return starships
        }
    }

    func getBy(id: Int) async throws -> Starship {
        try await SWAPI.load(
            router: StarshipsRouter.getDetails(id: id)
        )
    }
}

final class MockStarshipsService: StarshipsService {
    func getBy(ids: [Int]) async throws -> [Starship] {
        [.demo]
    }
    
    func getAll(page: Int) async throws -> [Starship] {
        [.demo]
    }

    func getBy(id: Int) async throws -> Starship {
        .demo
    }
}
