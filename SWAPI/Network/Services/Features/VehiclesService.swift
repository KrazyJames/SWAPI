//
//  VehiclesService.swift
//  SWAPI
//
//  Created by Jaime Escobar on 19/02/24.
//

import Foundation

protocol VehiclesService: NetworkService {
    func getAll(page: Int) async throws -> [Vehicle]
    func getBy(id: Int) async throws -> Vehicle
    func getBy(ids: [Int]) async throws -> [Vehicle]
}

protocol VehicleDetailsService {
    func getDetails(for vehicle: Vehicle) async throws -> VehicleDetails
}

final class LiveVehiclesService: VehiclesService {
    func getAll(page: Int) async throws -> [Vehicle] {
        let response: Response<Vehicle> = try await SWAPI.load(
            router: VehiclesRouter.getAll(page: page)
        )
        return response.results
    }

    func getBy(ids: [Int]) async throws -> [Vehicle] {
        try await withThrowingTaskGroup(
            of: Vehicle.self,
            returning: [Vehicle].self
        ) { group in
            ids.forEach { id in
                group.addTask {
                    try await self.getBy(id: id)
                }
            }
            var vehicles = [Vehicle]()
            while let vehicle = try await group.next() {
                vehicles.append(vehicle)
            }
            return vehicles
        }
    }

    func getBy(id: Int) async throws -> Vehicle {
        try await SWAPI.load(
            router: VehiclesRouter.getDetails(id: id)
        )
    }
}

final class MockVehiclesService: VehiclesService {
    func getBy(ids: [Int]) async throws -> [Vehicle] {
        [.demo]
    }

    func getAll(page: Int) async throws -> [Vehicle] {
        [.demo]
    }

    func getBy(id: Int) async throws -> Vehicle {
        .demo
    }
}
