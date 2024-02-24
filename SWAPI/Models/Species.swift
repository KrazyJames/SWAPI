//
//  Species.swift
//  SWAPI
//
//  Created by Jaime Escobar on 20/02/24.
//

import Foundation

struct Species: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let classification: String
    let designation: String
    let averageHeight: String
    let averageLifespan: String
    let language: String
    let homeworld: String
    let people: [String]
    let films: [String]
    let url: String

    init(
        id: Int,
        name: String,
        classification: String,
        designation: String,
        averageHeight: String,
        averageLifespan: String,
        language: String,
        homeworld: String,
        people: [String],
        films: [String],
        url: String
    ) {
        self.id = id
        self.name = name
        self.classification = classification
        self.designation = designation
        self.averageHeight = averageHeight
        self.averageLifespan = averageLifespan
        self.language = language
        self.homeworld = homeworld
        self.people = people
        self.films = films
        self.url = url
    }

    enum CodingKeys: CodingKey {
        case name
        case classification
        case designation
        case averageHeight
        case averageLifespan
        case language
        case homeworld
        case people
        case films
        case url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.classification = try container.decode(String.self, forKey: .classification)
        self.designation = try container.decode(String.self, forKey: .designation)
        self.averageHeight = try container.decode(String.self, forKey: .averageHeight)
        self.averageLifespan = try container.decode(String.self, forKey: .averageLifespan)
        self.language = try container.decode(String.self, forKey: .language)
        self.homeworld = try container.decode(String.self, forKey: .homeworld)
        self.people = try container.decode([String].self, forKey: .people)
        self.films = try container.decode([String].self, forKey: .films)
        self.url = try container.decode(String.self, forKey: .url)
        guard let last = url.split(separator: "/").last,
              let id = Int(last) else {
            throw NetworkError.decodingFailure
        }
        self.id = id
    }
}

extension Species {
    var peopleIDs: [Int] {
        people.compactMap(URL.init)
            .compactMap(\.lastPathComponent)
    }

    var filmIDs: [Int] {
        films.compactMap(URL.init)
            .compactMap(\.lastPathComponent)
    }
}

extension Species {
    static var demo: Self {
        .init(
            id: 3,
            name: "Wookie",
            classification: "Mammal",
            designation: "Sentient",
            averageHeight: "2.1",
            averageLifespan: "400",
            language: "Shyriiwook",
            homeworld: "https://swapi.dev/api/planets/14/",
            people: [
                "https://swapi.dev/api/people/13/"
            ],
            films: [
                "https://swapi.dev/api/films/1/",
                "https://swapi.dev/api/films/2/"
            ],
            url: "https://swapi.dev/api/species/3/"
        )
    }
}

struct SpeciesDetails: Identifiable {
    let id: Species.ID
    let people: [People]
    let films: [Film]
}

extension SpeciesDetails {
    static var demo: Self {
        .init(
            id: Species.demo.id,
            people: .init(arrayLiteral: .demo),
            films: .init(arrayLiteral: .demo)
        )
    }
}
