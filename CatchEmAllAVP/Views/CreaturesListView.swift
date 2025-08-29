//
//  CreaturesListView.swift
//  CatchEmAllAVP
//
//  Created by Bob Witmer on 2025-08-28.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct CreaturesListView: View {
    @State var creatures = Creatures()
//    var creatures: [String] = ["Pikachu", "Squirtle", "Charzard", "Snorlax"]
    
    var body: some View {
        NavigationStack {
            List(creatures.creaturesArray, id: \.self) { creature in
                NavigationLink {
                    DetailView(creature: creature)
                } label: {
                    Text(creature.name.capitalized)
                        .font(.title2)
                }


            }
            .listStyle(.plain)
            .navigationBarTitle("Pokémon")
        }
        .task {
            await creatures.getData()
        }
    }
}

#Preview(windowStyle: .automatic) {
    CreaturesListView()
}
