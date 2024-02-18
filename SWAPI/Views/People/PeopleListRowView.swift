//
//  PeopleListRowView.swift
//  SWAPI
//
//  Created by Jaime Escobar on 18/02/24.
//

import SwiftUI

struct PeopleListRowView: View {
    let person: People
    var body: some View {
        HStack(
            alignment: .top,
            spacing: 20
        ) {
            AsyncImage(
                url: person.urlImage
            ) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .aspectRatio(contentMode: .fill)
            .frame(
                width: 100,
                height: 100
            )
            .clipShape(
                .rect(cornerRadius: 10)
            )
            VStack(
                alignment: .leading,
                spacing: 10
            ) {
                Text(person.name)
                    .font(.headline)
                Text(person.bio)
                    .lineLimit(3)
            }
        }
    }
}

#Preview {
    PeopleListRowView(person: .demo)
}
