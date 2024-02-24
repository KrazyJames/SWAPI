//
//  SWAPIService.swift
//  SWAPI
//
//  Created by Jaime Escobar on 22/02/24.
//

import Foundation

@Observable
final class SWAPIService {
    private let people: any PeopleService
    private let planets: any PlanetsService
    private let films: any FilmsService
    private let species: any SpeciesService
    private let starships: any StarshipsService
    private let vehicle: any VehiclesService

    init(
        people: any PeopleService,
        planets: any PlanetsService,
        films: any FilmsService,
        species: any SpeciesService,
        starships: any StarshipsService,
        vehicle: any VehiclesService
    ) {
        self.people = people
        self.planets = planets
        self.films = films
        self.species = species
        self.starships = starships
        self.vehicle = vehicle
    }

    convenience init() {
        self.init(
            people: LivePeopleService(),
            planets: LivePlanetsService(),
            films: LiveFilmsService(),
            species: LiveSpeciesService(),
            starships: LiveStarshipsService(),
            vehicle: LiveVehiclesService()
        )
    }
}

extension SWAPIService {
    static var mock: Self {
        Self.init(
            people: MockPeopleService(),
            planets: MockPlanetsService(),
            films: MockFilmsService(),
            species: MockSpeciesService(),
            starships: MockStarshipsService(),
            vehicle: MockVehiclesService()
        )
    }
}

// MARK: - People
extension SWAPIService: PeopleDetailsService {
    func getBy(ids: [Int]) async throws -> [People] {
        try await people.getBy(ids: ids)
    }

    func getAll(page: Int) async throws -> [People] {
        try await people.getAll(page: page)
    }

    func getDetails(for people: People) async throws -> PeopleDetails {
        guard let planetId = people.homeworldID else {
            throw NetworkError.invalidRequest
        }
        let homeworld = try await self.planets.getBy(id: planetId)
        let films = try await self.films.getBy(ids: people.filmIDs)
        let species = try await self.species.getBy(ids: people.speciesIDs)
        let starships = try await self.starships.getBy(ids: people.starshipIDs)
        let vehicles = try await self.vehicle.getBy(ids: people.vehicleIDs)

        return .init(
            id: people.id,
            homeworld: homeworld,
            films: films,
            species: species,
            starships: starships,
            vehicles: vehicles
        )
    }

    func getBy(id: Int) async throws -> People {
        try await people.getBy(id: id)
    }
}

// MARK: - Planets
extension SWAPIService: PlanetDetailsService {
    func getBy(ids: [Int]) async throws -> [Planet] {
        try await planets.getBy(ids: ids)
    }

    func getAll(page: Int) async throws -> [Planet] {
        try await planets.getAll(page: page)
    }

    func getDetails(for planet: Planet) async throws -> PlanetDetails {
        let films = try await self.films.getBy(ids: planet.filmIDs)
        let residents = try await self.people.getBy(ids: planet.peopleIDs)

        return .init(
            id: planet.id,
            films: films,
            residents: residents
        )
    }

    func getBy(id: Int) async throws -> Planet {
        try await planets.getBy(id: id)
    }
}

// MARK: - Films
extension SWAPIService: FilmDetailsService {
    func getBy(ids: [Int]) async throws -> [Film] {
        try await films.getBy(ids: ids)
    }

    func getAll(page: Int) async throws -> [Film] {
        try await films.getAll(page: page)
    }

    func getDetails(for film: Film) async throws -> FilmDetails {
        let characters = try await self.people.getBy(ids: film.peopleIDs)
        let planets = try await self.planets.getBy(ids: film.planetIDs)
        let species = try await self.species.getBy(ids: film.speciesIDs)
        let starships = try await self.starships.getBy(ids: film.starshipIDs)
        let vehicles = try await self.vehicle.getBy(ids: film.vehicleIDs)

        return .init(
            id: film.id,
            characters: characters,
            planets: planets,
            species: species,
            starships: starships,
            vehicles: vehicles
        )
    }

    func getBy(id: Int) async throws -> Film {
        try await films.getBy(id: id)
    }
}

// MARK: - Species
extension SWAPIService: SpeciesDetailsService {
    func getBy(ids: [Int]) async throws -> [Species] {
        try await species.getBy(ids: ids)
    }

    func getAll(page: Int) async throws -> [Species] {
        try await species.getAll(page: page)
    }

    func getDetails(for species: Species) async throws -> SpeciesDetails {
        let people = try await self.people.getBy(ids: species.peopleIDs)
        let films = try await self.films.getBy(ids: species.filmIDs)

        return .init(
            id: species.id,
            people: people,
            films: films
        )
    }

    func getBy(id: Int) async throws -> Species {
        try await species.getBy(id: id)
    }
}

// MARK: - Starships
extension SWAPIService: StarshipDetailsService {
    func getBy(ids: [Int]) async throws -> [Starship] {
        try await starships.getBy(ids: ids)
    }

    func getAll(page: Int) async throws -> [Starship] {
        try await starships.getAll(page: page)
    }

    func getDetails(for starship: Starship) async throws -> StarshipDetails {
        let films = try await self.films.getBy(ids: starship.filmIDs)
        let pilots = try await self.people.getBy(ids: starship.peopleIDs)

        return .init(
            id: starship.id,
            films: films,
            pilots: pilots
        )
    }

    func getBy(id: Int) async throws -> Starship {
        try await starships.getBy(id: id)
    }
}

// MARK: - Vehicles
extension SWAPIService: VehicleDetailsService {
    func getBy(ids: [Int]) async throws -> [Vehicle] {
        try await vehicle.getBy(ids: ids)
    }

    func getAll(page: Int) async throws -> [Vehicle] {
        try await vehicle.getAll(page: page)
    }

    func getDetails(for vehicle: Vehicle) async throws -> VehicleDetails {
        let films = try await self.films.getBy(ids: vehicle.filmIDs)
        let pilots = try await self.people.getBy(ids: vehicle.peopleIDs)

        return .init(
            id: vehicle.id,
            pilots: pilots,
            films: films
        )
    }

    func getBy(id: Int) async throws -> Vehicle {
        try await vehicle.getBy(id: id)
    }
}
