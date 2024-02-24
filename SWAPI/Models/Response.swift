//
//  Response.swift
//  SWAPI
//
//  Created by Jaime Escobar on 19/02/24.
//

import Foundation

struct Response<T: Decodable>: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [T]
}
