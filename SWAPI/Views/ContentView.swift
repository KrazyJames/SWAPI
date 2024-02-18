//
//  ContentView.swift
//  SWAPI
//
//  Created by Jaime Escobar on 18/02/24.
//

import SwiftUI

enum Tab: String, Hashable, Identifiable, CaseIterable {
    var id: Int {
        self.hashValue
    }
    case people
    case planets
    case films
    case species
    case vehicles
    case starships

    var title: String {
        rawValue.capitalized
    }

    var icon: String {
        switch self {
        case .people:
            "person.fill"
        case .planets:
            "globe"
        case .films:
            "film.stack"
        case .species:
            "pawprint.fill"
        case .vehicles:
            "car.fill"
        case .starships:
            "airplane"
        }
    }
}

struct ContentView: View {
    @State private var selectedTab: Tab = .people
    var body: some View {
        TabView(selection: $selectedTab)  {
            PeopleListView()
                .tabItem {
                    Label(Tab.people.title, systemImage: Tab.people.icon)
                }
        }
    }
}

#Preview {
    ContentView()
}
