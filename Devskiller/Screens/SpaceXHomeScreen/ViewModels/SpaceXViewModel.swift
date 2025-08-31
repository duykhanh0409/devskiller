//
//  SpaceXViewModel.swift
//  Devskiller
//
//  Created by Khanh Nguyen on 31/8/25.
//  Copyright © 2025 Mindera. All rights reserved.
//

import Foundation
import Observation
import Combine

@Observable
class SpaceXViewModel {
    private let service: SpaceXServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Published Properties
    var company: Company?
    var launches: [Launch] = []
    var filteredLaunches: [Launch] = []
    var isLoading = false
    var errorMessage: String?
    
    // MARK: - Filter Properties
    var selectedYear: Int?
    var showSuccessfulOnly = false
    var sortOrder: SortOrder = .descending
    
    enum SortOrder {
        case ascending, descending
    }
    
    // MARK: - Available Years
    var availableYears: [Int] {
        let years = Set(launches.compactMap { launch -> Int? in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            guard let date = formatter.date(from: launch.dateUtc) else { return nil }
            return Calendar.current.component(.year, from: date)
        })
        return Array(years).sorted(by: >)
    }
    
    init(service: SpaceXServiceProtocol = SpaceXService.shared) {
        self.service = service
    }
    
    // MARK: - Data Loading
    func loadData() {
        isLoading = true
        errorMessage = nil
        
        let companyPublisher = service.fetchCompany()
        let launchesPublisher = service.fetchLaunches()
        
        Publishers.Zip(companyPublisher, launchesPublisher)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] company, launches in
                self?.company = company
                self?.launches = launches
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Filtering
    func applyFilters() {
        var filtered = launches
        
        // Filter by year
        if let selectedYear = selectedYear {
            filtered = filtered.filter { launch in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                guard let date = formatter.date(from: launch.dateUtc) else { return false }
                let year = Calendar.current.component(.year, from: date)
                return year == selectedYear
            }
        }
        
        // Filter by success
        if showSuccessfulOnly {
            filtered = filtered.filter { $0.success == true }
        }
        
        // Sort by date
        filtered.sort { launch1, launch2 in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            guard let date1 = formatter.date(from: launch1.dateUtc),
                  let date2 = formatter.date(from: launch2.dateUtc) else {
                return false
            }
            
            switch sortOrder {
            case .ascending:
                return date1 < date2
            case .descending:
                return date1 > date2
            }
        }
        
        filteredLaunches = filtered
    }
    
    func clearFilters() {
        selectedYear = nil
        showSuccessfulOnly = false
        sortOrder = .descending
        applyFilters()
    }
    
    func toggleSortOrder() {
        sortOrder = sortOrder == .ascending ? .descending : .ascending
        applyFilters()
    }
}
