//
//  NetworkRouter.swift
//  SWAPI
//
//  Created by Jaime Escobar on 19/02/24.
//

import HTTPTypes
import HTTPTypesFoundation

typealias HTTPMethod = HTTPRequest.Method
typealias NetworkRequest = HTTPRequest
typealias HeaderFields = HTTPFields

protocol NetworkRouter {
    var method: HTTPMethod { get }
    var path: String { get }
    var headerFields: HeaderFields { get }
    var request: NetworkRequest { get }
}

extension NetworkRouter {
    var request: NetworkRequest {
        .init(
            method: method,
            scheme: SWAPI.scheme,
            authority: SWAPI.authority,
            path: path,
            headerFields: headerFields
        )
    }
}

extension HTTPField.Name {
    static let page = Self("page")!
}
