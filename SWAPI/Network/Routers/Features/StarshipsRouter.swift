//
//  StarshipsRouter.swift
//  SWAPI
//
//  Created by Jaime Escobar on 21/02/24.
//

import Foundation

enum StarshipsRouter: NetworkRouter {
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
            "/starships"
        case let .getDetails(id):
            "/starships/\(id)"
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
