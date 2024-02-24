//
//  FilmsService.swift
//  SWAPI
//
//  Created by Jaime Escobar on 19/02/24.
//

import Foundation

protocol FilmsService: NetworkService {
    func getAll(page: Int) async throws -> [Film]
    func getBy(id: Int) async throws -> Film
    func getBy(ids: [Int]) async throws -> [Film]
}

protocol FilmDetailsService {
    func getDetails(for film: Film) async throws -> FilmDetails
}

final class LiveFilmsService: FilmsService {
    func getAll(page: Int) async throws -> [Film] {
        let response: Response<Film> = try await SWAPI.load(
            router: FilmsRouter.getAll(page: page)
        )
        return response.results
    }

    func getBy(ids: [Int]) async throws -> [Film] {
        try await withThrowingTaskGroup(
            of: Film.self,
            returning: [Film].self
        ) { group in
            ids.forEach { id in
                group.addTask {
                    try await self.getBy(id: id)
                }
            }
            var films = [Film]()
            while let film = try await group.next() {
                films.append(film)
            }
            return films
        }
    }

    func getBy(id: Int) async throws -> Film {
        try await SWAPI.load(
            router: FilmsRouter.getDetails(id: id)
        )
    }
}

final class MockFilmsService: FilmsService {
    func getBy(ids: [Int]) async throws -> [Film] {
        [.demo]
    }
    
    func getAll(page: Int) async throws -> [Film] {
        [.demo]
    }

    func getBy(id: Int) async throws -> Film {
        .demo
    }
}
