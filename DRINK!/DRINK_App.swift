//
//  DRINK_App.swift
//  DRINK!
//
//  Created by Paulo Cerqueira on 19/02/2025.
//

import SwiftUI
import SwiftData

@main
struct DRINK_App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()

        }.modelContainer(for: [WaterSettings.self])
    }
}
