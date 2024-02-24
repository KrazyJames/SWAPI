//
//  Starship.swift
//  SWAPI
//
//  Created by Jaime Escobar on 20/02/24.
//

import Foundation

struct Starship: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let model: String
    let starshipClass: String
    let manufaturer: String
    let costInCredits: String
    let length: String
    let crew: String
    let passengers: String
    let maxAtmospheringSpeed: String
    let MGLT: String
    let cargoCapacity: String
    let consumables: String
    let films: [String]
    let pilots: [String]
    let url: String

    init(
        id: Int,
        name: String,
        model: String,
        starshipClass: String,
        manufaturer: String,
        costInCredits: String,
        length: String,
        crew: String,
        passengers: String,
        maxAtmospheringSpeed: String,
        MGLT: String,
        cargoCapacity: String,
        consumables: String,
        films: [String],
        pilots: [String],
        url: String
    ) {
        self.id = id
        self.name = name
        self.model = model
        self.starshipClass = starshipClass
        self.manufaturer = manufaturer
        self.costInCredits = costInCredits
        self.length = length
        self.crew = crew
        self.passengers = passengers
        self.maxAtmospheringSpeed = maxAtmospheringSpeed
        self.MGLT = MGLT
        self.cargoCapacity = cargoCapacity
        self.consumables = consumables
        self.films = films
        self.pilots = pilots
        self.url = url
    }

    enum CodingKeys: CodingKey {
        case name
        case model
        case starshipClass
        case manufaturer
        case costInCredits
        case length
        case crew
        case passengers
        case maxAtmospheringSpeed
        case MGLT
        case cargoCapacity
        case consumables
        case films
        case pilots
        case url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.model = try container.decode(String.self, forKey: .model)
        self.starshipClass = try container.decode(String.self, forKey: .starshipClass)
        self.manufaturer = try container.decode(String.self, forKey: .manufaturer)
        self.costInCredits = try container.decode(String.self, forKey: .costInCredits)
        self.length = try container.decode(String.self, forKey: .length)
        self.crew = try container.decode(String.self, forKey: .crew)
        self.passengers = try container.decode(String.self, forKey: .passengers)
        self.maxAtmospheringSpeed = try container.decode(String.self, forKey: .maxAtmospheringSpeed)
        self.MGLT = try container.decode(String.self, forKey: .MGLT)
        self.cargoCapacity = try container.decode(String.self, forKey: .cargoCapacity)
        self.consumables = try container.decode(String.self, forKey: .consumables)
        self.films = try container.decode([String].self, forKey: .films)
        self.pilots = try container.decode([String].self, forKey: .pilots)
        self.url = try container.decode(String.self, forKey: .url)
        guard let last = url.split(separator: "/").last,
              let id = Int(last) else {
            throw NetworkError.decodingFailure
        }
        self.id = id
    }
}

extension Starship {
    var peopleIDs: [Int] {
        pilots.compactMap(URL.init)
            .compactMap(\.lastPathComponent)
    }

    var filmIDs: [Int] {
        films.compactMap(URL.init)
            .compactMap(\.lastPathComponent)
    }
}

extension Starship {
    static var demo: Self {
        .init(
            id: 9,
            name: "Death Star",
            model: "DS-1 Orbital Battle Station",
            starshipClass: "Deep Space Mobile Battlestation",
            manufaturer: "Imperial Department of Military Research, Sienar Fleet Systems",
            costInCredits: "1000000000000",
            length: "120000",
            crew: "342953",
            passengers: "843342",
            maxAtmospheringSpeed: "n/a",
            MGLT: "10 MGLT",
            cargoCapacity: "1000000000000",
            consumables: "3 years",
            films: .init(),
            pilots: .init(),
            url: "https://swapi.dev/api/starships/9/"
        )
    }
}

struct StarshipDetails: Identifiable {
    let id: Starship.ID
    let films: [Film]
    let pilots: [People]
}

extension StarshipDetails {
    static var demo: Self {
        .init(
            id: Starship.demo.id,
            films: .init(arrayLiteral: .demo),
            pilots: .init(arrayLiteral: .demo)
        )
    }
}
