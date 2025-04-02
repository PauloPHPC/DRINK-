//
//  HomeListViewModel.swift
//  DRINK!
//
//  Created by Paulo Cerqueira on 10/03/2025.
//

import HealthKit
import SwiftUI

class HomeListViewModel: ObservableObject {
    @Published var currentWaterIntake: Double = 0.0
    @Published var currentAlcoholIntake: Double = 0.0
    @Published var waterList: [WaterListData] = []
    @Published var errorMessage: String?
    @Published var showingErrorAlert: Bool = false

    private let healthManager = HealthManager()
    private let waterConsumption = HKQuantityType.quantityType(
        forIdentifier: .dietaryWater)!
    private let alcoholConsumption = HKQuantityType.quantityType(
        forIdentifier: .numberOfAlcoholicBeverages)!

    // Function to fetch for the water consumption until the time of update. Returns the double value of the quantity of water or error
    func fetchWater() {
        healthManager.fetchTotalQuantity(for: waterConsumption) {
            quantity, error in
            if let quantity = quantity {

                let totalInLiters = quantity.doubleValue(for: .liter())
                DispatchQueue.main.async {
                    self.currentWaterIntake = totalInLiters
                }

            } else {
                DispatchQueue.main.async {
                    self.currentWaterIntake = 0.0
                }
            }
        }
    }

    // Function to fetch for the alcohol intake. Returns the number of drinks or error
    func fetchAlcohol() {
        
        //Fetch for alcohol consumption
        healthManager.fetchTotalQuantity(for: alcoholConsumption) {
            quantity, error in
            if let quantity = quantity {
                
                let totalBeverages = quantity.doubleValue(for: .count())
                DispatchQueue.main.async {
                    self.currentAlcoholIntake = totalBeverages
                }
                
            } else {
                DispatchQueue.main.async {
                    self.currentAlcoholIntake = 0.0
                }
            }
        }
    }

    // Function to fetch for all the water consumption list. Returns an array with the quantity in liters and hour or error.
    func fetchListItems() {
        healthManager.fetchTodaysData(for: waterConsumption) { samples, error in

            if let quantitySamples = samples as? [HKQuantitySample] {
                let data = quantitySamples.map { sample in
                    WaterListData(sample: sample)
                }
                DispatchQueue.main.async {
                    self.waterList = data
                }
            } else {
                let errorDesc =
                    error?.localizedDescription
                    ?? "Unknown error on fetching for list items. Please reopen the app."
                DispatchQueue.main.async {
                    self.errorMessage = errorDesc
                    self.showingErrorAlert = true
                }
                print("ListItems error")
            }
        }
    }

    // Function to delete sample from the list. Returns the removal of the list or error.
    func deleteWaterSample(at offset: IndexSet) {
        offset.forEach { index in
            let waterData = waterList[index]
            healthManager.deleteSample(waterData.sample) { success, error in
                if success {
                    DispatchQueue.main.async {
                        self.waterList.remove(at: index)
                    }
                } else {
                    let errorDesc =
                        error?.localizedDescription
                        ?? "Unknown error on deleting water sample. Please reopen the app."
                    DispatchQueue.main.async {
                        self.errorMessage = errorDesc
                        self.showingErrorAlert = true
                    }
                    print("deleteWater error")
                }
            }
        }
    }

}
