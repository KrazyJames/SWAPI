//
//  SWAPIApp.swift
//  SWAPI
//
//  Created by Jaime Escobar on 18/02/24.
//

import SwiftUI

@main
struct SWAPIApp: App {
    let swapiService: SWAPIService = .init()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(swapiService)
        }
    }
}
