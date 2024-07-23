//
//  FilmDetailsView.swift
//  SWAPI
//
//  Created by Jaime Escobar on 24/02/24.
//

import SwiftUI

struct FilmDetailsView: View {
    @Environment(SWAPIService.self) private var service
    let film: Film
    @State private var details: FilmDetails?
    @State private var loading = false

    var body: some View {
        List {
            Section {
                LabeledContent("Director", value: film.director)
                LabeledContent("Producer", value: film.producer)
                NavigationLink {
                    ScrollView(
                        showsIndicators: false
                    ) {
                        Text(film.openingCrawl)
                            .font(.title.bold())
                            .foregroundStyle(Color.yellow)
                            .multilineTextAlignment(.center)
                            .shadow(color: .yellow, radius: 10)
                            .padding()
                    }
                    .preferredColorScheme(.dark)
                } label: {
                    Text("Movie crawl")
                }
            } header: {
                Text("Details")
            }
            if let details {
                Section("Characters") {
                    ForEach(details.characters) { person in
                        PeopleListRowView(person: person)
                    }
                }
            }
        }
        .navigationTitle(film.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await load()
        }
    }

    private func load() async {
        guard details == nil else { return }
        loading = true
        do {
            details = try await service.getDetails(for: film)
        } catch {
            debugPrint(error)
        }
        loading = false
    }
}

#Preview {
    NavigationStack {
        FilmDetailsView(film: .demo)
    }
    .environment(SWAPIService.mock)
}
