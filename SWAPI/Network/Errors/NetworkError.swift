//
//  NetworkError.swift
//  SWAPI
//
//  Created by Jaime Escobar on 19/02/24.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case invalidURL(url: String)
    case requestFailed(statusCode: Int)
    case invalidResponse
    case decodingFailure
}
