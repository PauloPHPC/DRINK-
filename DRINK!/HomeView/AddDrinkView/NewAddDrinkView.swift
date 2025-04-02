//
//  NewAddDrinkView.swift
//  DRINK!
//
//  Created by Paulo Cerqueira on 20/03/2025.
//

import SwiftUI

struct NewAddDrinkView: View {
    @State private var selectedDrink: DrinkType = .water
    @Binding var dataChanged: Bool
    
    enum DrinkType {
        case water
        case alcohol
    }
    
    var body: some View {
        
        VStack {
            Picker("Select a drink", selection: $selectedDrink) {
                Text("Water").tag(DrinkType.water)
                Text("Alcohol").tag(DrinkType.alcohol)
            }
            .pickerStyle(.segmented)
            .foregroundStyle(.themeColorBlue)
            
            switch selectedDrink {
            case .water:
                AddWaterView(dataChanged: $dataChanged)
                    .frame(width: 300, height: 200)
            case .alcohol:
                AddAlcoholView(dataChanged: $dataChanged)
                    .frame(width: 300, height: 200)
                
            }
        }
        .padding()
    }
}

#Preview {
    NewAddDrinkView(dataChanged: .constant(false))
}
