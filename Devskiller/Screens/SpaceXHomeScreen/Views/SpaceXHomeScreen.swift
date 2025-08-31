//
//  SpaceXHomeScreen.swift
//  Devskiller
//
//  Created by Khanh Nguyen on 31/8/25.
//  Copyright © 2025 Mindera. All rights reserved.
//

import SwiftUI

struct SpaceXHomeScreen: View {
    @State private var viewModel = SpaceXViewModel()
    @State private var showingFilters = false
    @State private var selectedLaunch: Launch?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Content
                if viewModel.isLoading {
                    loadingView
                } else if let errorMessage = viewModel.errorMessage {
                    errorView(message: errorMessage)
                } else {
                    contentView
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            if viewModel.company == nil {
                viewModel.loadData()
            }
        }
        .sheet(isPresented: $showingFilters) {
            FilterView(viewModel: viewModel)
        }
        .sheet(item: $selectedLaunch) { launch in
            LaunchDetailView(launch: launch)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("SpaceX")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Spacer()
            
            Button(action: {
                showingFilters = true
            }) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading SpaceX data...")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Error")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Retry") {
                viewModel.loadData()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Company Info Section
                if let company = viewModel.company {
                    CompanyInfoView(company: company)
                        .padding(.horizontal, 20)
                }
                
                // Launches Section Header
                launchesHeader
                
                // Launches List
                launchesList
            }
            .padding(.bottom, 20)
        }
    }
    
    private var launchesHeader: some View {
        HStack {
            Text("LAUNCHES")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(8)
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    private var launchesList: some View {
        LazyVStack(spacing: 12) {
            ForEach(viewModel.filteredLaunches) { launch in
                LaunchItemView(launch: launch) {
                    selectedLaunch = launch
                }
                .padding(.horizontal, 20)
                .onAppear {
                    // Trigger infinite scrolling when approaching the end
                    if launch.id == viewModel.filteredLaunches.last?.id {
                        viewModel.loadMoreData()
                    }
                }
            }
            
            // Loading indicator for infinite scrolling
            if viewModel.isLoadingMore {
                HStack {
                    Spacer()
                    ProgressView()
                        .padding()
                    Spacer()
                }
            }
        }
    }
}

struct LaunchDetailView: UIViewControllerRepresentable {
    let launch: Launch
    
    func makeUIViewController(context: Context) -> LaunchDetailViewController {
        return LaunchDetailViewController(launch: launch)
    }
    
    func updateUIViewController(_ uiViewController: LaunchDetailViewController, context: Context) {
        // No updates needed
    }
}
