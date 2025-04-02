//
//  HealthManager.swift
//  DRINK!
//
//  Created by Paulo Cerqueira on 28/02/2025.
//

import Foundation
import HealthKit
import SwiftUI

class HealthManager: ObservableObject {

    private let store = HKHealthStore()
    
    // The function below is only used once to ask for the permission to use the health data

    func requestAuthorization(completion: @escaping (Bool, Error?) -> (Void)) {

        let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater)!
        let alcoholType = HKObjectType.quantityType(
            forIdentifier: .numberOfAlcoholicBeverages)!

        let healthDataTypes: Set = [waterType, alcoholType]

        guard HKHealthStore.isHealthDataAvailable() else {
            return
        }

        store.requestAuthorization(
            toShare: healthDataTypes, read: healthDataTypes
        ) { success, error in
            completion(success, error)
        }

    }

    // The function below reads the water consumption once from the Health App, using HKStatisticsQuery

    func fetchTodaysData(for sampleType: HKSampleType, completion: @escaping ([HKSample]?, Error?) -> Void) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { query, samples, error in
            DispatchQueue.main.async {
                completion(samples,error)
            }
        }
        
        store.execute(query)
    }

    func fetchTotalQuantity(for sampleType: HKQuantityType, completion: @escaping (HKQuantity?, Error?) -> Void) {
        let healthStore = HKHealthStore()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        // A opção .cumulativeSum soma os valores de todos os samples que correspondem ao predicado
        let query = HKStatisticsQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, statistics, error in
            DispatchQueue.main.async {
                completion(statistics?.sumQuantity(), error)
            }
        }
        
        healthStore.execute(query)
    }
    
    // The function below allow for water intake to be saved to HealthKit

    func saveWaterIntake(
        amountInLiters: Double,
        date: Date = Date(),
        completion: @escaping (Bool, Error?) -> Void
    ) {

        guard
            let waterQuantityType = HKQuantityType.quantityType(
                forIdentifier: .dietaryWater)
        else {
            completion(false, nil)
            return
        }

        let quantity = HKQuantity(unit: .liter(), doubleValue: amountInLiters)

        let sample = HKQuantitySample(
            type: waterQuantityType,
            quantity: quantity,
            start: date,
            end: date)

        store.save(sample) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }

    }
    
    func saveAlcoholIntake(
        amount: Double,
        date: Date = Date(),
        completion: @escaping (Bool, Error?) -> Void
    ) {
        guard let alcoholConsumptionType = HKQuantityType.quantityType(forIdentifier: .numberOfAlcoholicBeverages) else {
            completion(false, nil)
            return
        }
        
        let quantity = HKQuantity(unit: .count(), doubleValue: amount)
        
        let beverageSample = HKQuantitySample(type: alcoholConsumptionType, quantity: quantity, start: date, end: date)
        
        store.save(beverageSample) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
        
        
    }
    
    func deleteSample(_ sample: HKSample, completion: @escaping (Bool, Error?) -> Void) {
        store.delete(sample) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }
    
}
