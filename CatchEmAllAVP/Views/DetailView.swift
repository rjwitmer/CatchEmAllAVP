//
//  DetailView.swift
//  CatchEmAllAVP
//
//  Created by Bob Witmer on 2025-08-29.
//

import SwiftUI

struct DetailView: View {
    let creature: Creature
    @State private var creatureDetail: CreatureDetail = CreatureDetail()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(creature.name.capitalized)
                .font(Font.custom("Avenir Next Condensed", fixedSize: 60))
                .bold()
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.gray)
                .padding(.bottom)
            
            HStack {
                
                creatureImage
                
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text("Height:")
                            .foregroundStyle(Color.red)
                        
                        Text(String(format: "%.1f", creatureDetail.height))
                            .font(.largeTitle)
                    }
                    .font(.largeTitle)
                    .bold()
                    
                    HStack(alignment: .top) {
                        Text("Weight:")
                            .foregroundStyle(Color.red)
                        
                        Text(String(format: "%.1f", creatureDetail.weight))
                            .font(.largeTitle)
                    }
                    .font(.largeTitle)
                    .bold()
                }
                
            }
            
            Spacer()
        }
        .padding()
        .task {
            creatureDetail.urlString = creature.url // URL passed over in getDetail for CreatureDetail
            await creatureDetail.getData()
        }
    }
}

extension DetailView {
    var creatureImage: some View {
        AsyncImage(url: URL(string: creatureDetail.imageURL)) { phase in
            if let image = phase.image {    // We have a valid image
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 8, x: 5, y: 5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.5), lineWidth: 1)
                    }
                
            } else if phase.error != nil {  // We've had an error, load a empty image
                Image(systemName: "questionmark.square.dashed")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 8, x: 5, y: 5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.5), lineWidth: 1)
                    }
            } else {    // Use a placeholder - image loading
//                        RoundedRectangle(cornerRadius: 10)
//                            .foregroundStyle(.clear)
                ProgressView()
                    .tint(Color.red)
                    .scaleEffect(4.0)
            }
        }
        .frame(width: 200, height: 200)
        .padding(.trailing)
        
    }
}

#Preview {
    DetailView(creature: Creature(name: "rattata", url: "https://pokeapi.co/api/v2/pokemon/19/"))   // Sample creature
}
