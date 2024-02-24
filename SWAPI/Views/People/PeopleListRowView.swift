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
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            Text(person.name)
                .font(.headline)
        }
    }
}

#Preview {
    List {
        PeopleListRowView(person: .demo)
    }
}
