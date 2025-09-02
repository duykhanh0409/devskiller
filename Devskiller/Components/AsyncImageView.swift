//
//  AsyncImageView.swift
//  Devskiller
//
//  Created by Khanh Nguyen on 31/8/25.
//  Copyright © 2025 Mindera. All rights reserved.
//

import SwiftUI
import Kingfisher

struct AsyncImageView: View {
    let url: String?
    let placeholder: String
    
    var body: some View {
        Group {
            if let url = url {
                KFImage(URL(string: url))
                    .placeholder {
                        VStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Loading...")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .frame(width: 40, height: 40)
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(systemName: placeholder)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray)
            }
        }
    }
}

