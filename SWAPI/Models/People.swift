//
//  People.swift
//  SWAPI
//
//  Created by Jaime Escobar on 18/02/24.
//

import Foundation

struct SWAPIPeople: Decodable {
    let name: String
    let height: String
    let mass: String
    let hairColor: String
    let skinColor: String
    let eyeColor: String
    let birthYear: String
    let gender: String
    let homeworld: String
    let films: [String]
    let species: [String]
    let vehicles: [String]
    let starships: [String]
    let url: String
}

extension SWAPIPeople {
    static var demo: Self {
        .init(
            name: "Luke Skywalker",
            height: "177",
            mass: "77",
            hairColor: "blond",
            skinColor: "fair",
            eyeColor: "blue",
            birthYear: "19BBY",
            gender: "male",
            homeworld: "",
            films: .init(),
            species: .init(),
            vehicles: .init(),
            starships: .init(),
            url: ""
        )
    }
}

struct SWDBCharacter: Codable, Identifiable {
    let id: String
    let name: String
    let bio: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case bio = "description"
        case image
    }

    init(
        id: String,
        name: String,
        bio: String,
        image: String
    ) {
        self.id = id
        self.name = name
        self.bio = bio
        self.image = image
    }

    init(from decoder: Decoder) throws {
        var container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.bio = try container.decode(String.self, forKey: .bio)
        self.image = try container.decode(String.self, forKey: .image)
    }
}

extension SWDBCharacter {
    static var demo: Self {
        .init(
            id: "64292927021f17e13fbc2062",
            name: "Luke Skywalker",
            bio: "Luke Skywalker was a Tatooine farmboy who rose from humble beginnings to become one of the greatest Jedi the galaxy has ever known. Along with his friends Princess Leia and Han Solo, Luke battled the evil Empire, discovered the truth of his parentage, and ended the tyranny of the Sith. A generation later, the location of the famed Jedi master was one of the galaxy’s greatest mysteries. Haunted by Ben Solo’s fall to evil and convinced the Jedi had to end, Luke sought exile on a distant world, ignoring the galaxy’s pleas for help. But his solitude would be interrupted – and Luke Skywalker had one final, momentous role to play in the struggle between good and evil.",
            image: "https://lumiere-a.akamaihd.net/v1/images/luke-skywalker-main_fb34a1ff.jpeg"
        )
    }
}

struct People: Identifiable, Hashable {
    let id: String
    let name: String
    let height: String
    let mass: String
    let hairColor: String
    let skinColor: String
    let eyeColor: String
    let birthYear: String
    let gender: String
    let homeworld: String
    let films: [String]
    let species: [String]
    let vehicles: [String]
    let starships: [String]
    let url: String
    let bio: String // description
    let image: String

    var peopleUrl: URL? {
        .init(string: url)
    }

    var urlImage: URL? {
        .init(string: image)
    }

    init(
        id: String,
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
        url: String,
        bio: String,
        image: String
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
        self.bio = bio
        self.image = image
    }

    init(people: SWAPIPeople, character: SWDBCharacter) {
        self.id = character.id
        self.name = people.name
        self.height = people.height
        self.mass = people.mass
        self.hairColor = people.hairColor
        self.skinColor = people.skinColor
        self.eyeColor = people.eyeColor
        self.birthYear = people.birthYear
        self.gender = people.gender
        self.homeworld = people.homeworld
        self.films = people.films
        self.species = people.species
        self.vehicles = people.vehicles
        self.starships = people.starships
        self.url = people.url
        self.bio = character.bio
        self.image = character.image
    }
}

extension People {
    static var demo: Self {
        .init(people: .demo, character: .demo)
    }
}
