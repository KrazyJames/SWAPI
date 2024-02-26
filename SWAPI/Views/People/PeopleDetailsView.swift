//
//  PeopleDetailsView.swift
//  SWAPI
//
//  Created by Jaime Escobar on 20/02/24.
//

import SwiftUI

struct PeopleDetailsView: View {
    @Environment(SWAPIService.self) private var service

    let people: People
    @State private var details: PeopleDetails?
    @State private var loading = false

    var body: some View {
        List {
            Section("Details") {
                if let homeworld = details?.homeworld.name {
                    LabeledContent("Homeworld", value: homeworld)
                }
                LabeledContent("Gender", value: people.gender.capitalized)
            }

            if let details {
                if !details.films.isEmpty {
                    Section {
                        ForEach(details.films) { film in
                            NavigationLink(film.title, value: film)
                        }
                    } header: {
                        Text("Films \(details.films.count)")
                    } footer: {
                        Text("\(people.name) appered in these movies")
                    }
                }
                if !details.species.isEmpty {
                    Section {
                        ForEach(details.species) { specie in
                            NavigationLink(specie.name, value: specie)
                        }
                    } header: {
                        Text("Species \(details.species.count)")
                    } footer: {
                        Text("\(people.name) belongs to these species")
                    }
                }
            }
        }
        .navigationDestination(for: Film.self) { film in
            Text(film.title)
        }
        .navigationDestination(for: Species.self) { species in
            Text(species.name)
        }
        .overlay {
            if loading {
                ProgressView()
            }
        }
        .navigationTitle(people.name)
        .task {
            await load()
        }
    }

    private func load() async {
        loading = true
        do {
            details = try await service.getDetails(for: people)
        } catch {
            debugPrint(error)
        }
        loading = false
    }
}

#Preview {
    NavigationStack {
        PeopleDetailsView(people: .demo)
    }
    .environment(SWAPIService.mock)
}
