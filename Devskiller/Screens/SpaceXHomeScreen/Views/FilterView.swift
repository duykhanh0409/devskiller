//
//  FilterView.swift
//  Devskiller
//
//  Created by Khanh Nguyen on 31/8/25.
//  Copyright © 2025 Mindera. All rights reserved.
//

import SwiftUI

struct FilterView: View {
    @Bindable var viewModel: SpaceXViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let yearFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            Form {
                Section("Year Filter") {
                    Picker("Select Year", selection: $viewModel.selectedYear) {
                        Text("All Years").tag(nil as Int?)
                        ForEach(viewModel.availableYears, id: \.self) { year in
                            Text(yearFormatter.string(from: NSNumber(value: year)) ?? "\(year)").tag(year as Int?)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Success Filter") {
                    Toggle("Show Successful Launches Only", isOn: $viewModel.showSuccessfulOnly)
                }
                
                Section("Sort Order") {
                    Picker("Sort Order", selection: $viewModel.sortOrder) {
                        Text("Newest First").tag(SpaceXViewModel.SortOrder.descending)
                        Text("Oldest First").tag(SpaceXViewModel.SortOrder.ascending)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    Button("Clear All Filters") {
                        viewModel.clearFilters()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onChange(of: viewModel.selectedYear) { _, _ in
            viewModel.applyFilters()
        }
        .onChange(of: viewModel.showSuccessfulOnly) { _, _ in
            viewModel.applyFilters()
        }
        .onChange(of: viewModel.sortOrder) { _, _ in
            viewModel.applyFilters()
        }
    }
}
