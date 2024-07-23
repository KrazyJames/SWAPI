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
    @State private var isLoading = false

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
                if isLoading {
                    ProgressView("Loading")
                } else if people.isEmpty {
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
            .navigationTitle("People")
            .task {
                await load()
            }
            .refreshable {
                Task {
                    await load()
                }
            }
        }
    }

    private func load() async {
        guard people.isEmpty else { return }
        isLoading = true
        people.removeAll()
        do {
            people = try await service.getAll(page: 1)
        } catch {
            debugPrint(error)
        }
        isLoading = false
    }
}

#Preview {
    PeopleListView()
        .environment(SWAPIService.init())
}
