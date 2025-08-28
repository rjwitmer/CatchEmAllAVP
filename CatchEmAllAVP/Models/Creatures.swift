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
        var next: String   // TODO: We want to change this to an optional
//        var previous: String?     // 'previous' isn't used in this app
        var results: [Result]
    }
    
    struct Result: Codable, Hashable {
        var name: String    // Pokémon name
        var url: String     // url for the detail on Pokémon
    }
    
    var urlString: String = "https://pokeapi.co/api/v2/pokemon"
    var count: Int = 0
    var creaturesArray: [Result] = []
    
    func getData() async {
        print("🕸️ We are accessing url: \(urlString)")
        
        // Create a URL
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a URL from: \(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)      // '_' could be replaced with 'response' but is not used in this app
            
             // Try to decode the JSON data into our own data structures
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("😡 JSON ERROR: Could not decode JSON data")
                return
            }
            
            self.count = returned.count
            self.urlString = returned.next
            self.creaturesArray = returned.results
            
            
        } catch {
            print("😡 ERROR: Could not get data from: \(urlString)")
        }
    }
}
