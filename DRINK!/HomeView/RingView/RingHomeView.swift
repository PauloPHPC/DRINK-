//
//  RingHomeView.swift
//  DRINK!
//
//  Created by Paulo Cerqueira on 26/02/2025.
//

import SwiftUI

struct RingHomeView: View {
    var progress: CGFloat {
        return(waterIntake/targetWaterIntake)
    }
    var targetWaterIntake: Double
    var alchoholIntake: Int
    var waterIntake: Double
    
    
    var body: some View {
    
        HStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundStyle(.white)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut, value: progress)
                    .shadow(radius: 10)
                    .foregroundStyle(.white)
            }
            .frame(width: 150, height: 150)
            
            Spacer()
            
            VStack {
                Text("Water")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.white)
                Text("\(returnNumber(number: waterIntake))L/\(returnNumber(number: targetWaterIntake))L")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.white)
                
                Text("Alcohol")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.yellow)
                
                Text("\(alchoholIntake) \(pluralSentence(number: alchoholIntake))")
                    .font(.title3)
                    .foregroundStyle(.yellow)
                    .bold()
            }
        }
        .padding()
        .background(Color.themeColorBlue)
        
        
    }
    
    func returnNumber(number: Double) -> String {
        return String(format: "%.2f", number)
    }
    
    func pluralSentence(number: Int) -> String {
        if number == 1 {
            return "Drink"
        } else {
            return "Drinks"
        }
    }
}

#Preview {
    RingHomeView(targetWaterIntake: 3.5, alchoholIntake: 4, waterIntake: 2.7)
}
