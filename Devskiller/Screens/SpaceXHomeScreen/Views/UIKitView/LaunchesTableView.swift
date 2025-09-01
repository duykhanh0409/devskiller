//
//  LaunchesTableView.swift
//  Devskiller
//
//  Created by Khanh Nguyen on 31/8/25.
//  Copyright © 2025 Mindera. All rights reserved.
//

import SwiftUI
import UIKit

struct LaunchesTableView: UIViewRepresentable {
    let launches: [Launch]
    let onLaunchSelected: (Launch) -> Void
    let onLoadMore: () -> Void
    let isLoadingMore: Bool
    
    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView()
        tableView.delegate = context.coordinator
        tableView.dataSource = context.coordinator
        tableView.register(LaunchTableViewCell.self, forCellReuseIdentifier: "LaunchCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        return tableView
    }
    
    func updateUIView(_ tableView: UITableView, context: Context) {
        context.coordinator.launches = launches
        context.coordinator.onLaunchSelected = onLaunchSelected
        context.coordinator.onLoadMore = onLoadMore
        context.coordinator.isLoadingMore = isLoadingMore
        tableView.reloadData()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        var parent: LaunchesTableView
        var launches: [Launch] = []
        var onLaunchSelected: ((Launch) -> Void)?
        var onLoadMore: (() -> Void)?
        var isLoadingMore: Bool = false
        
        init(_ parent: LaunchesTableView) {
            self.parent = parent
            self.launches = parent.launches
            self.onLaunchSelected = parent.onLaunchSelected
            self.onLoadMore = parent.onLoadMore
            self.isLoadingMore = parent.isLoadingMore
        }
        
        // MARK: - UITableViewDataSource
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return launches.count + (isLoadingMore ? 1 : 0)
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Show loading cell at the bottom
            if isLoadingMore && indexPath.row == launches.count {
                let loadingCell = UITableViewCell()
                loadingCell.backgroundColor = .clear
                loadingCell.selectionStyle = .none
                
                let activityIndicator = UIActivityIndicatorView(style: .medium)
                activityIndicator.startAnimating()
                loadingCell.contentView.addSubview(activityIndicator)
                activityIndicator.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    activityIndicator.centerXAnchor.constraint(equalTo: loadingCell.contentView.centerXAnchor),
                    activityIndicator.centerYAnchor.constraint(equalTo: loadingCell.contentView.centerYAnchor),
                    activityIndicator.topAnchor.constraint(equalTo: loadingCell.contentView.topAnchor, constant: 20),
                    activityIndicator.bottomAnchor.constraint(equalTo: loadingCell.contentView.bottomAnchor, constant: -20)
                ])
                
                return loadingCell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LaunchCell", for: indexPath) as! LaunchTableViewCell
            let launch = launches[indexPath.row]
            cell.configure(with: launch)
            cell.selectionStyle = .none
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if isLoadingMore && indexPath.row == launches.count {
                return
            }
            let launch = launches[indexPath.row]
            onLaunchSelected?(launch)
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if isLoadingMore && indexPath.row == launches.count {
                return 60
            }
            return 120
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.size.height
            
            // Load more when user scrolls to bottom
            if offsetY > contentHeight - height * 1.5 && !isLoadingMore {
                onLoadMore?()
            }
        }
    }
}

// MARK: - Custom UITableViewCell with SwiftUI Content
class LaunchTableViewCell: UITableViewCell {
    private var hostingController: UIHostingController<LaunchItemView>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        // Add spacing between cells
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        selectedBackgroundView = backgroundView
    }
    
    func configure(with launch: Launch) {
        // Remove existing hosting controller if any
        hostingController?.view.removeFromSuperview()
        hostingController?.removeFromParent()
        
        // Create SwiftUI view
        let launchItemView = LaunchItemView(launch: launch)
        
        let hostingController = UIHostingController(rootView: launchItemView)
        hostingController.view.backgroundColor = .clear
        
        contentView.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        self.hostingController = hostingController
    }
}
