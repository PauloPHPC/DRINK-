//
//  AddAlcoholView.swift
//  DRINK!
//
//  Created by Paulo Cerqueira on 24/03/2025.
//

import SwiftUI

struct AddAlcoholView: View {
    @ObservedObject var healthmanager = HealthManager()
    @Environment(\.dismiss) var dismiss
    @Binding var dataChanged: Bool
    
    @State var amount: Int = 1
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
                        .foregroundStyle(.buttonColorGold)
                }
                
                Spacer()
                
                Text(amount == 1 ? "\(amount) Drink" : "\(amount) Drinks")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.buttonColorGold)
                
                Spacer()
                
                Button {
                    amount += 1
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.buttonColorGold)
                }
                Spacer()
            }
            .padding(.top)
            
            
            Button {
                dataChanged.toggle()
                addAlcohol(amount: amount)
            } label: {
                Text("ADD")
                    .font(.title2)
                    .bold()
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.buttonColorGold)
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
    
    private func addAlcohol(amount: Int) {
        healthmanager.saveAlcoholIntake(amount: Double(amount)) { success, error in
            if success {
                dismiss()
            } else {
                errorMessage = "Failed to save your alcohol intake to Health, please allow the app to access your Health data."
                showAlert = true
            }
        }
    }
}

#Preview {
    AddAlcoholView(dataChanged: .constant(false))
}
