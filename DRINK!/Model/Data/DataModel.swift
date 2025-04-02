//
//  DataModel.swift
//  DRINK!
//
//  Created by Paulo Cerqueira on 23/02/2025.
//

import Foundation
import SwiftData

enum Gender: String, CaseIterable, Codable {
    case male = "Male"
    case female = "Female"
}

enum WorkoutIntensity: String, CaseIterable, Codable {
    case none = "None"
    case light = "Light"
    case moderate = "Moderate"
    case intense = "Intense"
}

enum WorkoutInterval: Double, CaseIterable, Codable {
    case halfHour = 0.5
    case oneHour = 1.0
    case oneAndHalfHours = 1.5
    case twoHours = 2.0
    case twoAndHalfHours = 2.5
    case threeHours = 3.0
}

@Model
class WaterSettings: Identifiable {

    var id: String
    var gender: Gender
    var initialTime: Date
    var finalTime: Date
    var workoutMode: Bool
    var workoutIntensity: WorkoutIntensity
    var workoutInterval: WorkoutInterval
    var finalWaterIntake: Double
    
    init(gender: Gender = .male,
         initialTime: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!,
         finalTime: Date = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: Date())!,
         workoutMode: Bool = false,
         workoutIntensity: WorkoutIntensity = .none,
         workoutInterval: WorkoutInterval = .halfHour,
         finalWaterIntake: Double = 0
        ) {
        self.id = UUID().uuidString
        self.gender = gender
        self.initialTime = initialTime
        self.finalTime = finalTime
        self.workoutMode = workoutMode
        self.workoutIntensity = workoutIntensity
        self.workoutInterval = workoutInterval
        self.finalWaterIntake = finalWaterIntake
    }
}
