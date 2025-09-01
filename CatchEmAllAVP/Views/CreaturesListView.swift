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
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                List(searchResults) { creature in
                    LazyVStack {
                        NavigationLink {
                            DetailView(creature: creature)
                        } label: {
                            Text("\(returnIndex(of: creature)). \(creature.name.capitalized)")
                                .font(.title2)
                        }
                    }
                    .task {
                        await creatures.loadNextPage(creature: creature)
                        }
                    
                }
                .listStyle(.automatic)
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
                .searchable(text: $searchText)
                
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
    
    var searchResults: [Creature] {
        if searchText.isEmpty {
            return creatures.creaturesArray
        } else {    // There is searchText data
            return creatures.creaturesArray.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func returnIndex(of creature: Creature) -> Int {
        guard let index = creatures.creaturesArray.firstIndex(where: {$0.name == creature.name}) else {
            return 0
        }
        return index + 1
    }
}

#Preview(windowStyle: .automatic) {
    CreaturesListView()
}
