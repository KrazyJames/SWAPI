//
//  Vehicles.swift
//  SWAPI
//
//  Created by Jaime Escobar on 19/02/24.
//

import Foundation

struct Vehicle: Decodable, Identifiable {
    let id: Int
    let name: String
    let model: String
    let manufacturer: String
    let cost: String
    let length: String
    let maxAtmospheringSpeed: String
    let crew: String
    let passengers: String
    let cargoCapacity: String
    let consumables: String
    let vehicleClass: String
    let pilots: [String]
    let films: [String]
    let url: String

    init(
        id: Int,
        name: String,
        model: String,
        manufacturer: String,
        cost: String,
        length: String,
        maxAtmospheringSpeed: String,
        crew: String,
        passengers: String,
        cargoCapacity: String,
        consumables: String,
        vehicleClass: String,
        pilots: [String],
        films: [String],
        url: String
    ) {
        self.id = id
        self.name = name
        self.model = model
        self.manufacturer = manufacturer
        self.cost = cost
        self.length = length
        self.maxAtmospheringSpeed = maxAtmospheringSpeed
        self.crew = crew
        self.passengers = passengers
        self.cargoCapacity = cargoCapacity
        self.consumables = consumables
        self.vehicleClass = vehicleClass
        self.pilots = pilots
        self.films = films
        self.url = url
    }

    enum CodingKeys: CodingKey {
        case name
        case model
        case manufacturer
        case cost
        case length
        case maxAtmospheringSpeed
        case crew
        case passengers
        case cargoCapacity
        case consumables
        case vehicleClass
        case pilots
        case films
        case url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.model = try container.decode(String.self, forKey: .model)
        self.manufacturer = try container.decode(String.self, forKey: .manufacturer)
        self.cost = try container.decode(String.self, forKey: .cost)
        self.length = try container.decode(String.self, forKey: .length)
        self.maxAtmospheringSpeed = try container.decode(String.self, forKey: .maxAtmospheringSpeed)
        self.crew = try container.decode(String.self, forKey: .crew)
        self.passengers = try container.decode(String.self, forKey: .passengers)
        self.cargoCapacity = try container.decode(String.self, forKey: .cargoCapacity)
        self.consumables = try container.decode(String.self, forKey: .consumables)
        self.vehicleClass = try container.decode(String.self, forKey: .vehicleClass)
        self.pilots = try container.decode([String].self, forKey: .pilots)
        self.films = try container.decode([String].self, forKey: .films)
        self.url = try container.decode(String.self, forKey: .url)
        guard let last = url.split(separator: "/").last,
              let id = Int(last) else {
            throw NetworkError.decodingFailure
        }
        self.id = id
    }
}

extension Vehicle {
    var peopleIDs: [Int] {
        pilots.compactMap(URL.init)
            .compactMap(\.lastPathComponent)
    }

    var filmIDs: [Int] {
        films.compactMap(URL.init)
            .compactMap(\.lastPathComponent)
    }
}

extension Vehicle {
    static var demo: Self {
        .init(
            id: 18,
            name: "AT-AT",
            model: "All Terrain Armored Transport",
            manufacturer: "Kuat Drive Yards, Imperial Department of Military Research",
            cost: "unknown",
            length: "20",
            maxAtmospheringSpeed: "60",
            crew: "5",
            passengers: "40",
            cargoCapacity: "1000",
            consumables: "unknown",
            vehicleClass: "assault walker",
            pilots: .init(),
            films: .init(),
            url: "https://swapi.dev/api/vehicles/18/"
        )
    }
}

struct VehicleDetails: Identifiable {
    let id: Vehicle.ID
    let pilots: [People]
    let films: [Film]
}

extension VehicleDetails {
    static var demo: Self {
        .init(
            id: Vehicle.demo.id,
            pilots: .init(arrayLiteral: .demo),
            films: .init(arrayLiteral: .demo)
        )
    }
}
