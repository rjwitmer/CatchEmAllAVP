//
//  Creatures.swift
//  CatchEmAllAVP
//
//  Created by Bob Witmer on 2025-08-28.
//

import Foundation

@Observable     // Will watch objects for changes so that SwiftUI will redraw the interface when needed
class Creatures {
    private struct Returned: Codable {
        var count: Int
        var next: String?   // Create as an optional to handle 'null' return
//        var previous: String?     // 'previous' isn't used in this app
        var results: [Creature]
    }
    
    var urlString: String = "https://pokeapi.co/api/v2/pokemon"
    var count: Int = 0
    var creaturesArray: [Creature] = []
    var isLoading: Bool = false
    
    func getData() async {
        print("🕸️ We are accessing url: \(urlString)")
        isLoading = true
        // Create a URL
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a URL from: \(urlString)")
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)      // '_' could be replaced with 'response' but is not used in this app
            
             // Try to decode the JSON data into our own data structures
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("😡 JSON ERROR: Could not decode JSON data")
                isLoading = false
                return
            }
            Task { @MainActor in
                self.count = returned.count
                self.urlString = returned.next ?? ""    
                self.creaturesArray = self.creaturesArray + returned.results
                isLoading = false
            }

            
            
        } catch {
            print("😡 ERROR: Could not get data from: \(urlString)")
            isLoading = false
        }
    }
    
    func loadAllCreatures() async {
        Task { @MainActor in
            guard urlString.hasPrefix("http") else { return }
            
            await getData()     // get nextpage of data
            await loadAllCreatures()    // Recursive call until there are no more pages to load 'next = null'
        }
    
    }
}
