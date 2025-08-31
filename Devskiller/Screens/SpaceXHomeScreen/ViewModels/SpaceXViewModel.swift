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
    
    var company: Company?
    var launches: [Launch] = []
    var filteredLaunches: [Launch] = []
    var isLoading = false
    var isLoadingMore = false
    var errorMessage: String?
    
    var currentPage = 1
    var hasNextPage = false
    var totalPages = 0
    let pageSize = 10
    
    var selectedYear: Int?
    var showSuccessfulOnly = false
    var sortOrder: SortOrder = .descending
    
    enum SortOrder {
        case ascending, descending
    }
    
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
    
    func loadData() {
        isLoading = true
        errorMessage = nil
        currentPage = 1
        launches = []
        
        let companyPublisher = service.fetchCompany()
        let launchesPublisher = service.fetchLaunchesPaginated(page: currentPage, limit: pageSize, query: buildQuery())
        
        Publishers.Zip(companyPublisher, launchesPublisher)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] company, response in
                self?.company = company
                self?.launches = response.docs
                self?.hasNextPage = response.hasNextPage
                self?.totalPages = response.totalPages
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }
    
    func loadMoreData() {
        guard !isLoadingMore && hasNextPage else { return }
        
        isLoadingMore = true
        currentPage += 1
        
        service.fetchLaunchesPaginated(page: currentPage, limit: pageSize, query: buildQuery())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoadingMore = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.launches.append(contentsOf: response.docs)
                self?.hasNextPage = response.hasNextPage
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Build Query
    private func buildQuery() -> [String: String] {
        var query: [String: String] = [:]
        
        if showSuccessfulOnly {
            query["success"] = "true"
        }
        
        return query
    }
    
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
        loadData() // Reload with new filters
    }
    
    func toggleSortOrder() {
        sortOrder = sortOrder == .ascending ? .descending : .ascending
        applyFilters()
    }
}
