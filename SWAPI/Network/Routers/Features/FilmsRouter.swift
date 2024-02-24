//
//  FilmsRouter.swift
//  SWAPI
//
//  Created by Jaime Escobar on 21/02/24.
//

import Foundation

enum FilmsRouter: NetworkRouter {
    case getAll(page: Int)
    case getDetails(id: Int)

    var method: HTTPMethod {
        switch self {
        case .getAll, .getDetails:
            .get
        }
    }

    var path: String {
        switch self {
        case .getAll:
            "/films"
        case let .getDetails(id):
            "/films/\(id)"
        }
    }

    var headerFields: HeaderFields {
        switch self {
        case let .getAll(page):
            .init([.init(name: .page, value: .init(page))])
        case .getDetails:
            .init()
        }
    }
}
