//
//  LaunchItemView.swift
//  Devskiller
//
//  Created by Khanh Nguyen on 31/8/25.
//  Copyright © 2025 Mindera. All rights reserved.
//

import SwiftUI

struct LaunchItemView: View {
    let launch: Launch
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Mission patch image
                AsyncImageView(
                    url: launch.links?.patch?.small,
                    placeholder: "photo"
                )
                .frame(width: 60, height: 60)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                
                // Launch details
                VStack(alignment: .leading, spacing: 4) {
                    Text("Mission: \(launch.name)")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text("Date/time: \(launch.formattedDate)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    Text("Rocket: \(launch.rocket ?? "Unknown")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    Text("Days \(launch.daysFromNow > 0 ? "from" : "since") now: \(launch.daysText)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Success indicator
                Image(systemName: launch.success == true ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(launch.success == true ? .green : .red)
                    .font(.title2)
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
