//
//  PeopleListView.swift
//  SWAPI
//
//  Created by Jaime Escobar on 18/02/24.
//

import SwiftUI

struct PeopleListView: View {
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
                            // TODO: - Refresh action
                        }) {
                            Text("Try again")
                        }
                        .buttonStyle(.borderedProminent)
                    })
                }
            }
            .navigationDestination(for: People.self) { person in
                Text(person.name)
            }
            .listStyle(.plain)
            .navigationTitle("People")
        }
    }
}

#Preview {
    PeopleListView()
}
