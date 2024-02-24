//
//  PlanetsService.swift
//  SWAPI
//
//  Created by Jaime Escobar on 19/02/24.
//

import Foundation

protocol PlanetsService: NetworkService {
    func getAll(page: Int) async throws -> [Planet]
    func getBy(id: Int) async throws -> Planet
    func getBy(ids: [Int]) async throws -> [Planet]
}

protocol PlanetDetailsService {
    func getDetails(for planet: Planet) async throws -> PlanetDetails
}

final class LivePlanetsService: PlanetsService {
    func getAll(page: Int) async throws -> [Planet] {
        let response: Response<Planet> = try await SWAPI.load(
            router: PlanetsRouter.getAll(page: page)
        )
        return response.results
    }

    func getBy(ids: [Int]) async throws -> [Planet] {
        try await withThrowingTaskGroup(
            of: Planet.self,
            returning: [Planet].self
        ) { group in
            ids.forEach { id in
                group.addTask {
                    try await self.getBy(id: id)
                }
            }
            var planets = [Planet]()
            while let person = try await group.next() {
                planets.append(person)
            }
            return planets
        }
    }

    func getBy(id: Int) async throws -> Planet {
        try await SWAPI.load(
            router: PlanetsRouter.getDetails(id: id)
        )
    }
}

final class MockPlanetsService: PlanetsService {
    func getBy(ids: [Int]) async throws -> [Planet] {
        [.demo]
    }
    
    func getAll(page: Int) async throws -> [Planet] {
        [.demo]
    }

    func getBy(id: Int) async throws -> Planet {
        .demo
    }
}
