//
//  WaterListData.swift
//  DRINK!
//
//  Created by Paulo Cerqueira on 09/03/2025.
//

import Foundation
import HealthKit

struct WaterListData: Identifiable {
    var id: UUID { sample.uuid }
    let sample: HKQuantitySample
    var date: Date { sample.startDate }
    var volume: Double { sample.quantity.doubleValue(for: .liter()) }

}
