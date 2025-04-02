//
//  TabViewMenu.swift
//  DRINK!
//
//  Created by Paulo Cerqueira on 25/02/2025.
//

import SwiftUI

struct TabViewMenu: View {
    @State private var plusIsPressed: Bool = false
    
    var body: some View {
        
            TabView {
                Tab("Home", systemImage: "house.fill") {
                    HomeView()
                }
                
                
                Tab("History", systemImage: "chart.xyaxis.line") {
                    
                }
                
                
                Tab("Settings", systemImage: "gear") {
                    NewFormSettingsView()
                }
                
                
            }

    }
    
}

#Preview {
    TabViewMenu()
}
