//
//  SWAPI.swift
//  SWAPI
//
//  Created by Jaime Escobar on 18/02/24.
//

import Foundation
import HTTPTypesFoundation

struct SWAPI {
    static let scheme = "https"
    static let authority = "swapi.dev/api"

    static func load<T: Decodable>(
        router: NetworkRouter,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        dateFormatter: DateFormatter = .init()
    ) async throws -> T {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        let (data, response) = try await session.data(for: router.request)
        switch response.status.kind {
        case .successful:
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingFailure
            }
        case .invalid, .informational, .redirection, .clientError, .serverError:
            throw NetworkError.requestFailed(statusCode: response.status.code)
        }
    }
}
