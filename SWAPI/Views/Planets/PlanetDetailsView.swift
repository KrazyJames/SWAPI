//
//  PlanetDetailsView.swift
//  SWAPI
//
//  Created by Jaime Escobar on 24/02/24.
//

import SwiftUI

struct PlanetDetailsView: View {
    @Environment(SWAPIService.self) private var service
    let planet: Planet
    @State private var details: PlanetDetails?
    @State private var loading = false
    var body: some View {
        List {
            Section {
                LabeledContent("Diameter", value: planet.diameter.appending(" KMs"))
                LabeledContent("Rotation period", value: planet.rotationPeriod.appending(" hours"))
                LabeledContent("Orbital period", value: planet.orbitalPeriod.appending(" days"))
                LabeledContent("Gravity", value: planet.gravity.appending(" G"))
                LabeledContent("Climate", value: planet.climate)
                LabeledContent("Terrain", value: planet.terrain)
                LabeledContent("Water", value: planet.surfaceWater.appending(" %"))
            } header: {
                Text("Details")
            }

            if let details {
                Section {
                    ForEach(details.residents) { person in
                        NavigationLink(value: person) {
                            PeopleListRowView(person: person)
                        }
                    }
                } header: {
                    Text("Residents")
                } footer: {
                    Text("Total population: \(planet.population)")
                }

                Section {
                    ForEach(details.films) { film in
                        NavigationLink(value: film) {
                            Text(film.title)
                        }
                    }
                } header: {
                    Text("Films")
                } footer: {
                    Text("Films in which this planet has appeared in")
                }

            }
        }
        .overlay {
            if loading {
                ProgressView()
            }
        }
        .navigationTitle(planet.name)
        .toolbarTitleDisplayMode(.inline)
        .navigationDestination(for: People.self) { person in
            PeopleDetailsView(people: person)
        }
        .navigationDestination(for: Film.self) { film in
            Text(film.title)
        }
        .task {
            await load()
        }
    }

    private func load() async {
        loading = true
        do {
            details = try await service.getDetails(for: planet)
        } catch {
            debugPrint(error.localizedDescription)
        }
        loading = false
    }
}

#Preview {
    NavigationStack {
        PlanetDetailsView(planet: .demo)
    }
    .environment(SWAPIService.mock)
}
