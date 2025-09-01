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
        print("khanh Array(2006...2025).sorted(by: >)\(Array(2006...2025).sorted(by: >))")
        return Array(2006...2025).sorted(by: >)
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
                self?.filteredLaunches = response.docs
                self?.hasNextPage = response.hasNextPage
                self?.totalPages = response.totalPages
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
                self?.filteredLaunches.append(contentsOf: response.docs)
                self?.hasNextPage = response.hasNextPage
            }
            .store(in: &cancellables)
    }
    
    private func buildQuery() -> LaunchQueryFilter {
        var dateUtc: DateRangeFilter?
        var success: Bool?
        
        if let selectedYear = selectedYear {
            let startOfYear = "\(selectedYear)-01-01T00:00:00.000Z"
            let endOfYear = "\(selectedYear)-12-31T23:59:59.999Z"
            dateUtc = DateRangeFilter(gte: startOfYear, lte: endOfYear)
        }
        
        // Filter by success
        if showSuccessfulOnly {
            success = true
        }
        
        return LaunchQueryFilter(dateUtc: dateUtc, success: success)
    }
    
    func applyFilters() {
        loadData()
    }
    
    func clearFilters() {
        selectedYear = nil
        showSuccessfulOnly = false
        sortOrder = .descending
        loadData()
    }
    
    func toggleSortOrder() {
        sortOrder = sortOrder == .ascending ? .descending : .ascending
        applyFilters()
    }
}
