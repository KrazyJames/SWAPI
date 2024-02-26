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
    // case species
    // case vehicles
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
        /* case .species:
            "pawprint.fill"
        case .vehicles:
            "car.fill"
             */
        case .starships:
            "airplane"
        }
    }
}

struct ContentView: View {
    @State private var selectedTab: Tab = .films
    var body: some View {
        TabView(selection: $selectedTab)  {
            ForEach(Tab.allCases) { tab in
                tabView(for: tab)
                    .tabItem {
                        Label(tab.title, systemImage: tab.icon)
                    }
                    .tag(tab)
            }
        }
    }

    @ViewBuilder func tabView(for tab: Tab) -> some View {
        switch tab {
        case .people:
            PeopleListView()
        case .planets:
            PlanetsListView()
        case .films:
            FilmsListView()
        default:
            Text(tab.title)
        }
    }
}

#Preview {
    ContentView()
        .environment(SWAPIService.mock)
}
