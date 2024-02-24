//
//  PlanetsListView.swift
//  SWAPI
//
//  Created by Jaime Escobar on 24/02/24.
//

import SwiftUI

struct PlanetsListView: View {
    @Environment(SWAPIService.self) private var service
    @State private var planets: [Planet] = []

    var body: some View {
        NavigationStack {
            List {
                ForEach(planets) { planet in
                    NavigationLink(value: planet) {
                        Text(planet.name)
                            .font(.headline)
                    }
                }
            }
            .overlay {
                if planets.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No planets", image: .globeSlash)
                    }, description: {
                        Text("No planets to show yet.")
                    }, actions: {
                        Button(action: {
                            Task {
                                await load()
                            }
                        }) {
                            Text("Try again")
                        }
                        .buttonStyle(.borderedProminent)
                    })
                }
            }
            .navigationDestination(for: Planet.self) { planet in
                PlanetDetailsView(planet: planet)
            }
            .navigationTitle("Planet")
            .task {
                await load()
            }
        }
    }

    private func load() async {
        do {
            planets = try await service.getAll(page: 1)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

#Preview {
    PlanetsListView()
        .environment(SWAPIService.mock)
}

