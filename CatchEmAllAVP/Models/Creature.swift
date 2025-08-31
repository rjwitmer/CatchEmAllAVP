//
//  Creature.swift
//  CatchEmAllAVP
//
//  Created by Bob Witmer on 2025-08-29.
//


import Foundation

struct Creature: Codable, Identifiable {
    let id: String = UUID().uuidString  // Unique ID for each creature
    var name: String    // Pokémon name
    var url: String     // url for the detail on Pokémon
    
    enum CodingKeys: CodingKey {    // Ignore the id when decoding
        case name
        case url
    }
}
