//
//  NetworkService.swift
//  SWAPI
//
//  Created by Jaime Escobar on 19/02/24.
//

import Foundation

protocol NetworkService {
    associatedtype T: Identifiable, Decodable
    func getAll(page: Int) async throws -> [T]
    func getBy(ids: [T.ID]) async throws -> [T]
    func getBy(id: T.ID) async throws -> T
}
