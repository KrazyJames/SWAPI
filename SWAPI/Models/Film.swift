//
//  Film.swift
//  SWAPI
//
//  Created by Jaime Escobar on 20/02/24.
//

import Foundation

struct Film: Decodable, Identifiable, Hashable {
    let id: Int
    let title: String
    let episodeId: Int
    let openingCrawl: String
    let director: String
    let producer: String
    let releaseDate: Date
    let characters: [String]
    let planets: [String]
    let species: [String]
    let starships: [String]
    let vehicles: [String]
    let url: String

    init(
        id: Int,
        title: String,
        episodeId: Int,
        openingCrawl: String,
        director: String,
        producer: String,
        releaseDate: Date,
        characters: [String],
        planets: [String],
        species: [String],
        starships: [String],
        vehicles: [String],
        url: String
    ) {
        self.id = id
        self.title = title
        self.episodeId = episodeId
        self.openingCrawl = openingCrawl
        self.director = director
        self.producer = producer
        self.releaseDate = releaseDate
        self.characters = characters
        self.planets = planets
        self.species = species
        self.starships = starships
        self.vehicles = vehicles
        self.url = url
    }

    enum CodingKeys: CodingKey {
        case title
        case episodeId
        case openingCrawl
        case director
        case producer
        case releaseDate
        case characters
        case planets
        case species
        case starships
        case vehicles
        case url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.episodeId = try container.decode(Int.self, forKey: .episodeId)
        self.openingCrawl = try container.decode(String.self, forKey: .openingCrawl)
        self.director = try container.decode(String.self, forKey: .director)
        self.producer = try container.decode(String.self, forKey: .producer)
        self.releaseDate = try container.decode(Date.self, forKey: .releaseDate)
        self.characters = try container.decode([String].self, forKey: .characters)
        self.planets = try container.decode([String].self, forKey: .planets)
        self.species = try container.decode([String].self, forKey: .species)
        self.starships = try container.decode([String].self, forKey: .starships)
        self.vehicles = try container.decode([String].self, forKey: .vehicles)
        self.url = try container.decode(String.self, forKey: .url)
        guard let last = url.split(separator: "/").last,
              let id = Int(last) else {
            throw NetworkError.decodingFailure
        }
        self.id = id
    }
}

extension Film {
    static var demo: Self {
        .init(
            id: 1,
            title: "A New Hope",
            episodeId: 4,
            openingCrawl: "It is a period of civil war.\n\nRebel spaceships, striking\n\nfrom a hidden base, have won\n\ntheir first victory against\n\nthe evil Galactic Empire.\n\n\n\nDuring the battle, Rebel\n\nspies managed to steal secret\r\nplans to the Empire's\n\nultimate weapon, the DEATH\n\nSTAR, an armored space\n\nstation with enough power\n\nto destroy an entire planet.\n\n\n\nPursued by the Empire's\n\nsinister agents, Princess\n\nLeia races home aboard her\n\nstarship, custodian of the\n\nstolen plans that can save her\n\npeople and restore\n\nfreedom to the galaxy....",
            director: "George Lucas",
            producer: "Gary Kurtz, Rick McCallum",
            releaseDate: .now,
            characters: .init(),
            planets: .init(),
            species: .init(),
            starships: .init(),
            vehicles: .init(),
            url: "https://swapi.dev/api/films/1/"
        )
    }
}

extension Film {
    var peopleIDs: [Int] {
        characters.compactMap(URL.init)
            .compactMap(\.lastPathComponent)
    }

    var planetIDs: [Int] {
        planets.compactMap(URL.init)
            .compactMap(\.lastPathComponent)
    }

    var speciesIDs: [Int] {
        species.compactMap(URL.init)
            .compactMap(\.lastPathComponent)
    }

    var starshipIDs: [Int] {
        starships.compactMap(URL.init)
            .compactMap(\.lastPathComponent)
    }

    var vehicleIDs: [Int] {
        vehicles.compactMap(URL.init)
            .compactMap(\.lastPathComponent)
    }
}

struct FilmDetails: Identifiable {
    let id: Film.ID
    let characters: [People]
    let planets: [Planet]
    let species: [Species]
    let starships: [Starship]
    let vehicles: [Vehicle]
}

extension FilmDetails {
    static var demo: Self {
        .init(
            id: Film.demo.id,
            characters: .init(arrayLiteral: .demo),
            planets: .init(arrayLiteral: .demo),
            species: .init(arrayLiteral: .demo),
            starships: .init(arrayLiteral: .demo),
            vehicles: .init(arrayLiteral: .demo)
        )
    }
}
