//
//  Starship.swift
//  SWAPI
//
//  Created by Jaime Escobar on 20/02/24.
//

import Foundation

protocol Transport: Identifiable {
    var name: String { get }
    var model: String { get }
    var manufacturer: String { get }
    var cost: String { get }
    var `class`: String { get }
    var length: String { get }
    var crew: String { get }
    var passengers: String { get }
    var maxAtmospheringSpeed: String { get }
    var cargoCapacity: String { get }
    var consumables: String { get }
    var films: [String] { get }
    var pilots: [String] { get }
    var url: String { get }
}

struct Starship: Transport, Decodable, Hashable {
    let id: Int
    let name: String //
    let model: String //
    let `class`: String //
    let manufacturer: String //
    let cost: String
    let length: String //
    let crew: String //
    let passengers: String //
    let maxAtmospheringSpeed: String //
    let MGLT: String
    let cargoCapacity: String //
    let consumables: String //
    let films: [String] //
    let pilots: [String] //
    let url: String //

    init(
        id: Int,
        name: String,
        model: String,
        `class`: String,
        manufacturer: String,
        cost: String,
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
        self.class = `class`
        self.manufacturer = manufacturer
        self.cost = cost
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

    enum CodingKeys: String, CodingKey {
        case name
        case model
        case `class` = "starshipClass"
        case manufacturer
        case cost = "costInCredits"
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
        self.class = try container.decodeIfPresent(String.self, forKey: .class) ?? "N/E"
        self.manufacturer = try container.decode(String.self, forKey: .manufacturer)
        self.cost = try container.decodeIfPresent(String.self, forKey: .cost) ?? "Unknown"
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
            class: "Deep Space Mobile Battlestation",
            manufacturer: "Imperial Department of Military Research, Sienar Fleet Systems",
            cost: "1000000000000",
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
