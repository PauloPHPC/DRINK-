//
//  MenuStyle+.swift
//  DRINK!
//
//  Created by Paulo Cerqueira on 26/02/2025.
//

import Foundation
import SwiftUI

struct MenuSavingStyle: MenuStyle {
    
    let color: Color
    
    init(color: Color) {
        self.color = color
    }
    
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .padding()
            .frame(width: 120, height: 50)
            .foregroundStyle(.white)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
