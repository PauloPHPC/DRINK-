//
//  HomeView.swift
//  DRINK!
//
//  Created by Paulo Cerqueira on 25/02/2025.
//

import SwiftUI

struct HomeView: View {
    @State private var isPressed = false
    @State private var dataChanged: Bool = false

    @State private var date: DateFormatter = DateFormatter()

    var body: some View {
        NavigationView {
            ZStack {
                HomeListView(dataChanged: $dataChanged)
                    
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack {

                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.themeColorBlue)
                                .padding()

                            Image(systemName: "plus.app")
                                .font(.system(size: 25))
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.white)

                        }
                        .padding()
                        .onTapGesture {
                            isPressed = true
                        }
                    }
                }

            }
            .sheet(isPresented: $isPressed) {
                NewAddDrinkView(dataChanged: $dataChanged)
                .presentationDetents([.height(300)])
                    .presentationDragIndicator(.visible)
                    .presentationContentInteraction(.resizes)

            }
            .navigationTitle(Text("DRINK!"))
            .navigationBarTitleDisplayMode(.automatic)

        }
    }
}

#Preview {
    HomeView()
}
