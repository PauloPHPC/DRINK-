//
//  CustomStyleTextModifier.swift
//  DRINK!
//
//  Created by Paulo Cerqueira on 20/02/2025.
//

import Foundation
import SwiftUI

struct HeaderTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(.themeColorBlue)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
    }
}

struct CaptionTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundStyle(Color(.darkGray))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
    }
}

extension View {
    public func headerTextStyle() -> some View {
        self.modifier(HeaderTextStyle())
    }
    
    public func captionTextStyle() -> some View {
        self.modifier(CaptionTextStyle())
    }
}
