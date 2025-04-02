//
//  AddWaterView.swift
//  DRINK!
//
//  Created by Paulo Cerqueira on 24/03/2025.
//

import SwiftUI

struct AddWaterView: View {
    @ObservedObject var healthmanager = HealthManager()
    @Environment(\.dismiss) var dismiss
    @Binding var dataChanged: Bool
    
    @State private var amount: Int = 250
    @State private var errorMessage: String?
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    if amount > 0 {
                        amount -= 1
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.themeColorBlue)
                }

                Spacer()

                    Text("\(amount) ml")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.themeColorBlue)

                Spacer()
                
                Button {
                    amount += 1
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.themeColorBlue)
                }

                Spacer()
            }
            .padding(.top)
            
            
            Button {
                dataChanged.toggle()
                addWater(amount: amount)
            } label: {
                Text("ADD")
                    .font(.title2)
                    .bold()
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 30))
            .padding(.top)
        }
        .frame(maxWidth: 300, maxHeight: 300)
        .alert("Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            if let errorMessage = errorMessage {
                Text(errorMessage)
            }
        }
    }
    
    
    private func addWater(amount: Int) {
        healthmanager.saveWaterIntake(amountInLiters: (Double(amount)/1000)) { success, error in
            if success {
                dismiss()
            } else {
                errorMessage = "Failed to save your water intake to Health, please allow the app to access your Health data."
                showAlert = true
            }
        }
    }
}

#Preview {
    AddWaterView(dataChanged: .constant(false))
}
