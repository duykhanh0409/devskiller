//
//  LaunchDetailViewController.swift
//  Devskiller
//
//  Created by Khanh Nguyen on 31/8/25.
//  Copyright © 2025 Mindera. All rights reserved.
//

import UIKit

class LaunchDetailViewController: UIViewController {
    
    private let launch: Launch
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var missionPatchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.systemGray6
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var missionNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var rocketLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var successLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var linksStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(launch: Launch) {
        self.launch = launch
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithLaunch()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        title = "Launch Details"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(missionPatchImageView)
        contentView.addSubview(missionNameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(rocketLabel)
        contentView.addSubview(successLabel)
        contentView.addSubview(detailsLabel)
        contentView.addSubview(linksStackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            missionPatchImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            missionPatchImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            missionPatchImageView.widthAnchor.constraint(equalToConstant: 120),
            missionPatchImageView.heightAnchor.constraint(equalToConstant: 120),
            
            missionNameLabel.topAnchor.constraint(equalTo: missionPatchImageView.bottomAnchor, constant: 20),
            missionNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            missionNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: missionNameLabel.bottomAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            rocketLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            rocketLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            rocketLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            successLabel.topAnchor.constraint(equalTo: rocketLabel.bottomAnchor, constant: 16),
            successLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            successLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            detailsLabel.topAnchor.constraint(equalTo: successLabel.bottomAnchor, constant: 16),
            detailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            linksStackView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 20),
            linksStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            linksStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            linksStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func configureWithLaunch() {
        missionNameLabel.text = launch.name
        dateLabel.text = "Date: \(launch.formattedDate)"
        rocketLabel.text = "Rocket: \(launch.rocket ?? "Unknown")"
        
        if let success = launch.success {
            successLabel.text = success ? "✅ Successful Launch" : "❌ Failed Launch"
            successLabel.textColor = success ? UIColor.systemGreen : UIColor.systemRed
        } else {
            successLabel.text = "⏳ Launch Status Unknown"
            successLabel.textColor = UIColor.systemOrange
        }
        
        if let details = launch.details, !details.isEmpty {
            detailsLabel.text = details
        } else {
            detailsLabel.text = "No details available for this launch."
        }
        
        // Load mission patch image
        if let imageUrl = launch.links?.patch?.large ?? launch.links?.patch?.small,
           let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                DispatchQueue.main.async {
                    if let data = data, let image = UIImage(data: data) {
                        self?.missionPatchImageView.image = image
                    } else {
                        self?.missionPatchImageView.image = UIImage(systemName: "photo")
                        self?.missionPatchImageView.tintColor = UIColor.systemGray
                    }
                }
            }.resume()
        }
        
        // Add link buttons
        addLinkButtons()
    }
    
    private func addLinkButtons() {
        guard let links = launch.links else { return }
        
        let linkData = [
            ("Article", links.article),
            ("Wikipedia", links.wikipedia),
            ("Webcast", links.webcast)
        ]
        
        for (title, urlString) in linkData {
            if let urlString = urlString, let url = URL(string: urlString) {
                let button = UIButton(type: .system)
                button.setTitle(title, for: .normal)
                button.backgroundColor = UIColor.systemBlue
                button.setTitleColor(UIColor.white, for: .normal)
                button.layer.cornerRadius = 8
                button.addTarget(self, action: #selector(linkButtonTapped(_:)), for: .touchUpInside)
                button.tag = linksStackView.arrangedSubviews.count
                
                // Store URL in button's accessibility identifier
                button.accessibilityIdentifier = urlString
                
                linksStackView.addArrangedSubview(button)
                
                button.heightAnchor.constraint(equalToConstant: 44).isActive = true
            }
        }
    }
    

    
    @objc private func linkButtonTapped(_ sender: UIButton) {
        if let urlString = sender.accessibilityIdentifier, let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
