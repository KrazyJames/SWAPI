//
//  PeopleListView.swift
//  SWAPI
//
//  Created by Jaime Escobar on 18/02/24.
//

import SwiftUI

struct PeopleListView: View {
    @Environment(SWAPIService.self) private var service
    @State private var people: [People] = []

    var body: some View {
        NavigationStack {
            List {
                ForEach(people) { person in
                    NavigationLink(value: person) {
                        PeopleListRowView(person: person)
                    }
                }
            }
            .overlay {
                if people.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No people", systemImage: "person.2.slash.fill")
                    }, description: {
                        Text("No people to show yet.")
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
            .navigationDestination(for: People.self) { person in
                PeopleDetailsView(people: person)
            }
            .listStyle(.plain)
            .navigationTitle("People")
            .task {
                await load()
            }
        }
    }

    private func load() async {
        do {
            people = try await service.getAll(page: 1)
        } catch {
            debugPrint(error)
        }
    }
}

#Preview {
    PeopleListView()
        .environment(SWAPIService.mock)
}
