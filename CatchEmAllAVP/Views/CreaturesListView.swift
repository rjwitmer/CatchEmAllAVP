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
            ZStack {
                List(0..<creatures.creaturesArray.count, id: \.self) { index in
                    LazyVStack {
                        NavigationLink {
                            DetailView(creature: creatures.creaturesArray[index])
                        } label: {
                            Text("\(index + 1). \(creatures.creaturesArray[index].name.capitalized)")
                                .font(.title2)
                        }
                    }
                    .task {
                        guard let lastCreature = creatures.creaturesArray.last else { return }
                        if creatures.creaturesArray[index].name == lastCreature.name && creatures.urlString.hasPrefix("http") {
                            await creatures.getData()
                        }
                    }
                    
                }
                .listStyle(.plain)
                .navigationBarTitle("Pokémon")
                .toolbar {

                    ToolbarItem(placement: .status) {
                        Text("\(creatures.creaturesArray.count) of \(creatures.count) creatures")
                    }
                    
                    ToolbarItem(placement: .bottomBar) {
                        Button("Load All") {
                            Task {
                                await creatures.loadAllCreatures()
                            }
                        }
                        .buttonStyle(.borderedProminent)

                    }
                }
                
                if creatures.isLoading {
                    ProgressView()
                        .tint(Color.red)
                        .scaleEffect(4.0)
                }
                
            }
        }
        .task {
            await creatures.getData()
        }
    }
}

#Preview(windowStyle: .automatic) {
    CreaturesListView()
}
