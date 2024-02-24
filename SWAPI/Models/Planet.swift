//
//  Planet.swift
//  SWAPI
//
//  Created by Jaime Escobar on 20/02/24.
//

import Foundation

struct Planet: Decodable, Identifiable, Hashable {
    let id: Int
    let climate: String
    let diameter: String
    let gravity: String
    let name: String
    let orbitalPeriod: String
    let population: String
    let residents: [String]
    let films: [String]
    let rotationPeriod: String
    let surfaceWater: String
    let terrain: String
    let url: String

    init(
        id: Int,
        climate: String,
        diameter: String,
        gravity: String,
        name: String,
        orbitalPeriod: String,
        population: String,
        residents: [String],
        films: [String],
        rotationPeriod: String,
        surfaceWater: String,
        terrain: String,
        url: String
    ) {
        self.id = id
        self.climate = climate
        self.diameter = diameter
        self.gravity = gravity
        self.name = name
        self.orbitalPeriod = orbitalPeriod
        self.population = population
        self.residents = residents
        self.films = films
        self.rotationPeriod = rotationPeriod
        self.surfaceWater = surfaceWater
        self.terrain = terrain
        self.url = url
    }

    enum CodingKeys: CodingKey {
        case climate
        case diameter
        case gravity
        case name
        case orbitalPeriod
        case population
        case residents
        case films
        case rotationPeriod
        case surfaceWater
        case terrain
        case url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.climate = try container.decode(String.self, forKey: .climate)
        self.diameter = try container.decode(String.self, forKey: .diameter)
        self.gravity = try container.decode(String.self, forKey: .gravity)
        self.name = try container.decode(String.self, forKey: .name)
        self.orbitalPeriod = try container.decode(String.self, forKey: .orbitalPeriod)
        self.population = try container.decode(String.self, forKey: .population)
        self.residents = try container.decode([String].self, forKey: .residents)
        self.films = try container.decode([String].self, forKey: .films)
        self.rotationPeriod = try container.decode(String.self, forKey: .rotationPeriod)
        self.surfaceWater = try container.decode(String.self, forKey: .surfaceWater)
        self.terrain = try container.decode(String.self, forKey: .terrain)
        self.url = try container.decode(String.self, forKey: .url)
        guard let last = url.split(separator: "/").last,
              let id = Int(last) else {
            throw NetworkError.decodingFailure
        }
        self.id = id
    }
}

extension Planet {
    var filmIDs: [Int] {
        films.compactMap(URL.init)
            .compactMap(\.lastPathComponent)
    }

    var peopleIDs: [Int] {
        residents.compactMap(URL.init)
            .compactMap(\.lastPathComponent)
    }
}

extension Planet {
    static var demo: Self {
        .init(
            id: 1,
            climate: "Arid",
            diameter: "10465",
            gravity: "1",
            name: "Tatooine",
            orbitalPeriod: "304",
            population: "100000",
            residents: .init(),
            films: .init(),
            rotationPeriod: "23",
            surfaceWater: "1",
            terrain: "Dessert",
            url: ""
        )
    }
}

struct PlanetDetails {
    let id: Planet.ID
    let films: [Film]
    let residents: [People]
}

extension PlanetDetails {
    static var demo: Self {
        .init(
            id: Planet.demo.id,
            films: .init(arrayLiteral: .demo),
            residents: .init(arrayLiteral: .demo)
        )
    }
}
