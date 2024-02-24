//
//  People.swift
//  SWAPI
//
//  Created by Jaime Escobar on 18/02/24.
//

import Foundation

struct People: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let height: String
    let mass: String
    let hairColor: String
    let skinColor: String
    let eyeColor: String
    let birthYear: String
    let gender: String
    let homeworld: String // Planet
    let films: [String] // Films
    let species: [String] // Species
    let vehicles: [String] // Vehicles
    let starships: [String] // Starships
    let url: String

    init(
        id: Int,
        name: String,
        height: String,
        mass: String,
        hairColor: String,
        skinColor: String,
        eyeColor: String,
        birthYear: String,
        gender: String,
        homeworld: String,
        films: [String],
        species: [String],
        vehicles: [String],
        starships: [String],
        url: String
    ) {
        self.id = id
        self.name = name
        self.height = height
        self.mass = mass
        self.hairColor = hairColor
        self.skinColor = skinColor
        self.eyeColor = eyeColor
        self.birthYear = birthYear
        self.gender = gender
        self.homeworld = homeworld
        self.films = films
        self.species = species
        self.vehicles = vehicles
        self.starships = starships
        self.url = url
    }

    enum CodingKeys: CodingKey {
        case name
        case height
        case mass
        case hairColor
        case skinColor
        case eyeColor
        case birthYear
        case gender
        case homeworld
        case films
        case species
        case vehicles
        case starships
        case url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.height = try container.decode(String.self, forKey: .height)
        self.mass = try container.decode(String.self, forKey: .mass)
        self.hairColor = try container.decode(String.self, forKey: .hairColor)
        self.skinColor = try container.decode(String.self, forKey: .skinColor)
        self.eyeColor = try container.decode(String.self, forKey: .eyeColor)
        self.birthYear = try container.decode(String.self, forKey: .birthYear)
        self.gender = try container.decode(String.self, forKey: .gender)
        self.homeworld = try container.decode(String.self, forKey: .homeworld)
        self.films = try container.decode([String].self, forKey: .films)
        self.species = try container.decode([String].self, forKey: .species)
        self.vehicles = try container.decode([String].self, forKey: .vehicles)
        self.starships = try container.decode([String].self, forKey: .starships)
        self.url = try container.decode(String.self, forKey: .url)
        guard let last = url.split(separator: "/").last,
              let id = Int(last) else {
            throw NetworkError.decodingFailure
        }
        self.id = id
    }
}

extension People {
    static var demo: Self {
        .init(
            id: 1,
            name: "Luke Skywalker",
            height: "177",
            mass: "77",
            hairColor: "blond",
            skinColor: "fair",
            eyeColor: "blue",
            birthYear: "19BBY",
            gender: "male",
            homeworld: "https://swapi.dev/api/planets/1/",
            films: .init(arrayLiteral: ""),
            species: .init(arrayLiteral: ""),
            vehicles: .init(arrayLiteral: ""),
            starships: .init(arrayLiteral: ""),
            url: "https://swapi.dev/api/people/1/"
        )
    }
}

extension People {
    var homeworldID: Int? {
        guard let id = URL(
            string: homeworld
        )?.lastPathComponent else {
            return nil
        }
        return id
    }

    var filmIDs: [Int] {
        films.compactMap(URL.init)
            .compactMap(\.lastPathComponent)
    }

    var speciesIDs: [Int] {
        species.compactMap(URL.init)
            .compactMap(\.lastPathComponent)
    }

    var vehicleIDs: [Int] {
        vehicles.compactMap(URL.init)
            .compactMap(\.lastPathComponent)
    }

    var starshipIDs: [Int] {
        starships.compactMap(URL.init)
            .compactMap(\.lastPathComponent)
    }
}

extension URL {
    var lastPathComponent: Int? {
        guard let last = pathComponents.last,
              let id = Int(last) else {
            return nil
        }
        return id
    }
}

struct PeopleDetails: Identifiable {
    let id: People.ID
    let homeworld: Planet
    let films: [Film]
    let species: [Species]
    let starships: [Starship]
    let vehicles: [Vehicle]
}

extension PeopleDetails {
    static var demo: Self {
        .init(
            id: 1,
            homeworld: .demo,
            films: .init(arrayLiteral: .demo),
            species: .init(arrayLiteral: .demo),
            starships: .init(arrayLiteral: .demo),
            vehicles: .init(arrayLiteral: .demo)
        )
    }
}
