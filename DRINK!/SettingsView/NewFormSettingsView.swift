//
//  NewFormSettingsView.swift
//  DRINK!
//
//  Created by Paulo Cerqueira on 18/03/2025.
//

import SwiftData
import SwiftUI

struct NewFormSettingsView: View {
    @Environment(\.modelContext) private var context

    @Query private var allSettings: [WaterSettings]

    @State private var settings = WaterSettings()
    @State private var notificationEnable: Bool = false
    private var notificationsMethods = NotificationMethods()
    private var healtManager = HealthManager()

    var body: some View {

        NavigationView {
            Form {
                // Preferences

                Section(
                    header: Text("Preferences"),
                    footer: Text(
                        "We provide personalized recommendations based on your preferences. Our base recommendation came from the European Food Safety Authority (EFSA). \n Link:"
                    )
                ) {
                    Picker(
                        "Biological Sex",
                        systemImage: "figure.stand.dress.line.vertical.figure",
                        selection: $settings.gender
                    ) {
                        Text("Male").tag(Gender.male)
                        Text("Female").tag(Gender.female)
                    }
                    .pickerStyle(.navigationLink)
                    .onChange(of: settings.gender) { oldValue, newValue in
                        calculateWaterInake()
                    }
                }

                // Notifications

                Section(
                    header: Text("Notifications"),
                    footer: Text(
                        "Allow notifications for us to send you reminders to stay hydrated. You can personalize the interval when you want to be reminded."
                    )
                ) {

                    Toggle(isOn: $notificationEnable) {
                        Label("Enable notifications", systemImage: "bell.fill")
                    }
                    .toggleStyle(.switch)

                    if notificationEnable {
                        DatePicker(
                            "From:",
                            selection: $settings.initialTime,
                            in: ...settings.finalTime,
                            displayedComponents: .hourAndMinute
                        )

                        DatePicker(
                            "To:", selection: $settings.finalTime,
                            in: settings.initialTime...,
                            displayedComponents: .hourAndMinute
                        )
                    }
                }

                // Workout

                Section(
                    header: Text("Workout"),
                    footer: Text(
                        "Your workout intensity can add to your water intake. ")
                ) {
                    Toggle(isOn: $settings.workoutMode) {
                        Label(
                            "Workout Mode", systemImage: "figure.run.treadmill")
                    }

                    if settings.workoutMode {
                        Picker(
                            "Workout Intensity",
                            selection: $settings.workoutIntensity
                        ) {
                            Text("None").tag(WorkoutIntensity.none)
                            Text("Light").tag(WorkoutIntensity.light)
                            Text("Moderate").tag(WorkoutIntensity.moderate)
                            Text("Intense").tag(WorkoutIntensity.intense)
                        }
                        .pickerStyle(.navigationLink)
                        .onChange(of: settings.workoutIntensity) {
                            oldValue, newValue in
                            calculateWaterInake()
                        }

                        Picker(
                            "Workout Interval (Hours)",
                            selection: $settings.workoutInterval
                        ) {
                            Text("00:30").tag(WorkoutInterval.halfHour)
                            Text("01:00").tag(WorkoutInterval.oneHour)
                            Text("01:30").tag(WorkoutInterval.oneAndHalfHours)
                            Text("02:00").tag(WorkoutInterval.twoHours)
                            Text("02:30").tag(WorkoutInterval.twoAndHalfHours)
                            Text("03:00").tag(WorkoutInterval.threeHours)
                        }
                        .pickerStyle(.navigationLink)
                    }

                }

                Section {
                    HStack {
                        Spacer()
                        Text(String(format: "%.2f", settings.finalWaterIntake))
                        Spacer()
                    }
                } header: {
                    Text("Your recommended daily water intake")
                } footer: {
                    Text("Liters/Day")
                }

            }
            .navigationTitle(Text("Settings"))
            .navigationBarTitleDisplayMode(.automatic)
            .onAppear {
                loadSettings()
            }
        }
        .onDisappear {
            saveSettings()
            healthAutorizationStatus()
            notification(notifications: notificationEnable)
        }
    }

    // MARK: FUNCTIONS

    private func notification(notifications: Bool) {
        if notifications {
            notificationsMethods.scheduleNotification(
                startTime: settings.initialTime, endTime: settings.finalTime,
                recomendedAmount: settings.finalWaterIntake)
        } else {
            return
        }
    }

    private func loadSettings() {
        if let existingSettings = allSettings.first {
            settings = existingSettings
        } else {
            let newSettings = WaterSettings(
                gender: .male, initialTime: .now - 8.0, finalTime: .now,
                workoutMode: false, workoutIntensity: .none,
                workoutInterval: .halfHour, finalWaterIntake: 0
            )
            context.insert(newSettings)
            settings = newSettings
        }
    }

    private func saveSettings() {
        do {
            try context.save()
        } catch {
            print("Error saving settings: \(error)")
        }
    }

    private func calculateWaterInake() {
        var totalIntake: Double = settings.gender == .male ? 2.5 : 2.0
        if settings.workoutMode {
            switch settings.workoutIntensity {
            case .light:
                totalIntake += 0.5
            case .moderate:
                totalIntake += 0.75
            case .intense:
                totalIntake += 1.0
            default:
                break
            }
        }
        settings.finalWaterIntake = totalIntake
    }

    private func healthAutorizationStatus() {
        healtManager.requestAuthorization { status, error in
            if let error = error {
                print("Error requesting health authorization: \(error)")
                return
            }

        }
    }
}

#Preview {
    NewFormSettingsView()
}
