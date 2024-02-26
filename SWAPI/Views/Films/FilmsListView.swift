//
//  FilmsListView.swift
//  SWAPI
//
//  Created by Jaime Escobar on 24/02/24.
//

import SwiftUI

struct FilmsListView: View {
    @Environment(SWAPIService.self) private var service
    @State private var films: [Film] = []

    var body: some View {
        NavigationStack {
            List {
                ForEach(films) { film in
                    NavigationLink(value: film) {
                        FilmListRowView(film: film)
                    }
                }
            }
            .overlay {
                if films.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No films", image: .filmStackSlash)
                    }, description: {
                        Text("No films to show yet.")
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
            .navigationDestination(for: Film.self) { film in
                FilmDetailsView(film: film)
            }
            .navigationTitle("Films")
            .task {
                await load()
            }
        }
    }

    private func load() async {
        do {
            films = try await service.getAll(page: 1)
        } catch {
            debugPrint(error)
        }
    }
}

#Preview {
    FilmsListView()
        .environment(SWAPIService.mock)
}
