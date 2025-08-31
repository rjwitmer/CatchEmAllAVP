//
//  CreatureDetail.swift
//  CatchEmAllAVP
//
//  Created by Bob Witmer on 2025-08-29.
//

import Foundation

@Observable     // Will watch objects for changes so that SwiftUI will redraw the interface when needed
class CreatureDetail {
    private struct Returned: Codable {
        var height: Double
        var weight: Double
        var sprites: Sprite
    }
    
    struct Sprite: Codable {
        var other: Other
    }
    
    struct Other: Codable {
        var officialArtwork: OfficialArtwork
        
        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
        }
    }
    
    struct OfficialArtwork: Codable {
        var front_default: String?      // This might return null, which is nil in Swift
    }
    
    var urlString: String = ""  //TODO: Update with the string passed from the API sprite default
    var height: Double = 0.0
    var weight: Double = 0.0
    var imageURL: String = ""
    
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
            self.height = returned.height
            self.weight = returned.weight
            self.imageURL = returned.sprites.other.officialArtwork.front_default ?? "n/a"   // If null use 'n/a' which is an invalid URL
            
            
        } catch {
            print("😡 ERROR: Could not get data from: \(urlString)")
        }
    }
}
