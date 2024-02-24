//
//  SpeciesService.swift
//  SWAPI
//
//  Created by Jaime Escobar on 21/02/24.
//

import Foundation

protocol SpeciesService: NetworkService {
    func getAll(page: Int) async throws -> [Species]
    func getBy(id: Int) async throws -> Species
    func getBy(ids: [Int]) async throws -> [Species]
}

protocol SpeciesDetailsService {
    func getDetails(for species: Species) async throws -> SpeciesDetails
}

final class LiveSpeciesService: SpeciesService {
    func getAll(page: Int) async throws -> [Species] {
        let response: Response<Species> = try await SWAPI.load(
            router: SpeciesRouter.getAll(page: page)
        )
        return response.results
    }

    func getBy(ids: [Int]) async throws -> [Species] {
        try await withThrowingTaskGroup(
            of: Species.self,
            returning: [Species].self
        ) { group in
            ids.forEach { id in
                group.addTask {
                    try await self.getBy(id: id)
                }
            }
            var species = [Species]()
            while let specie = try await group.next() {
                species.append(specie)
            }
            return species
        }
    }

    func getBy(id: Int) async throws -> Species {
        try await SWAPI.load(
            router: SpeciesRouter.getDetails(id: id)
        )
    }
}

final class MockSpeciesService: SpeciesService {
    func getBy(ids: [Int]) async throws -> [Species] {
        [.demo]
    }
    
    func getAll(page: Int) async throws -> [Species] {
        [.demo]
    }

    func getBy(id: Int) async throws -> Species {
        .demo
    }
}
