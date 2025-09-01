//
//  LaunchDetailView.swift
//  Devskiller
//
//  Created by Khanh Nguyen on 31/8/25.
//  Copyright © 2025 Mindera. All rights reserved.
//

import SwiftUI

struct LaunchDetailView: View {
    let launch: Launch
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                
                    missionDetailsSection
                    
                    launchDetailsSection
                    
                    if let links = launch.links {
                        linksSection(links: links)
                    }
                }
                .padding(20)
            }
            .navigationTitle("Launch Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var headerSection: some View {
        HStack(spacing: 16) {
            AsyncImageView(
                url: launch.links?.patch?.large,
                placeholder: "photo"
            )
            .frame(width: 120, height: 120)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(launch.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Flight #\(launch.flightNumber)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: launch.success == true ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(launch.success == true ? .green : .red)
                    
                    Text(launch.success == true ? "Successful" : "Failed")
                        .font(.subheadline)
                        .foregroundColor(launch.success == true ? .green : .red)
                }
            }
            
            Spacer()
        }
    }
    
    private var missionDetailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Mission Details")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 8) {
                detailRow(title: "Date", value: launch.formattedDate)
                detailRow(title: "Rocket", value: launch.rocket ?? "Unknown")
                detailRow(title: "Launchpad", value: launch.launchpad ?? "Unknown")
                detailRow(title: "Days from now", value: launch.daysText)
                
                if let details = launch.details {
                    detailRow(title: "Details", value: details)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var launchDetailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Launch Information")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 8) {
                detailRow(title: "Date Precision", value: launch.datePrecision)
                detailRow(title: "Upcoming", value: launch.upcoming ? "Yes" : "No")
                detailRow(title: "Auto Update", value: launch.autoUpdate ? "Yes" : "No")
                
                if let window = launch.window {
                    detailRow(title: "Window", value: "\(window) seconds")
                }
                
                if let net = launch.net {
                    detailRow(title: "Net", value: net ? "Yes" : "No")
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func linksSection(links: LaunchLinks) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Links")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                if let webcast = links.webcast {
                    linkButton(title: "Webcast", url: webcast, icon: "play.circle")
                }
                
                if let article = links.article {
                    linkButton(title: "Article", url: article, icon: "doc.text")
                }
                
                if let wikipedia = links.wikipedia {
                    linkButton(title: "Wikipedia", url: wikipedia, icon: "book")
                }
                
                if let presskit = links.presskit {
                    linkButton(title: "Press Kit", url: presskit, icon: "doc.richtext")
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func detailRow(title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
    
    private func linkButton(title: String, url: String, icon: String) -> some View {
        Button(action: {
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
        }) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundColor(.blue)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
    }
}
