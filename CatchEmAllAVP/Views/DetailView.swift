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
                Image(systemName: "figure.run.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96, height: 96)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 8, x: 5, y: 5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.5), lineWidth: 1)
                    }
                    .padding(.trailing)
                
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

#Preview {
    DetailView(creature: Creature(name: "Pikachu", url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"))
}
