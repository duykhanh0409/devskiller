//
//  CompanyInfoView.swift
//  Devskiller
//
//  Created by Khanh Nguyen on 31/8/25.
//  Copyright © 2025 Mindera. All rights reserved.
//

import SwiftUI

struct CompanyInfoView: View {
    let company: Company
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("COMPANY")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("\(company.name) was founded by \(company.founder) in \(company.founded).")
                    .font(.body)
                    .foregroundColor(.primary)
                
                Text("It has now \(company.employees) employees, \(company.launchSites) launch sites, and is valued at USD \(formatValuation(company.valuation)).")
                    .font(.body)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private func formatValuation(_ valuation: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: valuation)) ?? "\(valuation)"
    }
}
