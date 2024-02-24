//
//  FilmListRowView.swift
//  SWAPI
//
//  Created by Jaime Escobar on 24/02/24.
//

import SwiftUI

struct FilmListRowView: View {
    let film: Film
    var body: some View {
        VStack(alignment: .leading) {
            Text(film.title)
                .font(.headline)
            Text(film.releaseDate.formatted(
                date: .abbreviated,
                time: .omitted
            ))
        }
    }
}

#Preview {
    List {
        FilmListRowView(film: .demo)
    }
}
