//
//  HomeListView.swift
//  DRINK!
//
//  Created by Paulo Cerqueira on 26/02/2025.
//

import HealthKit
import HealthKitUI
import SwiftData
import SwiftUI

struct HomeListView: View {
    @StateObject private var viewModel = HomeListViewModel()
    @State private var notifications = NotificationMethods()
    @Binding var dataChanged: Bool
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    @Query private var waterSettings: [WaterSettings]

    var body: some View {
        VStack {
            List {
                Section {
                    VStack {
                        Text("Today's Water Intake")
                            .font(.headline)
                            .foregroundStyle(.white)
                        
                        Divider()
                            .background(Color.white)
                        
                        RingHomeView(
                            targetWaterIntake: getWaterIntakeTarget(),
                            alchoholIntake: Int(viewModel.currentAlcoholIntake),
                            waterIntake: viewModel.currentWaterIntake)
                    }
                    .padding()
                    .background(Color.themeColorBlue)
                    
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                
                Section {
                    ForEach(viewModel.waterList) {WaterListData in
                        
                        HStack {
                            Text("\(WaterListData.date, formatter: dateFormatter)")
                                .foregroundStyle(.gray)
                            Spacer()
                            Text("\(WaterListData.volume * 1000, specifier: "%.f") ml")
                            Image(systemName: "waterbottle.fill")
                        }
                    }
                    .onDelete(perform: { offset in
                        viewModel.deleteWaterSample(at: offset)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            refreshData()
                        }
                    })
                   //) .onDelete(perform: viewModel.deleteWaterSample)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .onChange(of: dataChanged, { _, _ in
            refreshData()
        })
        .refreshable {
            refreshData()
        }
        .onAppear() {
            refreshData()
        }
        .alert("Error", isPresented: $viewModel.showingErrorAlert) {
            Button("OK", role:.cancel) {}
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }

    private func getWaterIntakeTarget() -> Double {
        return waterSettings.first?.finalWaterIntake ?? 0.0
    }
    
    private func refreshData() {
        viewModel.fetchWater()
        viewModel.fetchAlcohol()
        viewModel.fetchListItems()
    }
}

#Preview {
    HomeListView(dataChanged: .constant(false))
}
