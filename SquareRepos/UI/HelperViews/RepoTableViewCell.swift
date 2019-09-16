//
//  RepoTableViewCell.swift
//  SquareRepos
//
//  Created by Pratima on 12/09/19.
//  Copyright © 2019 Pratima. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTypography
import RxSwift

// 
// Custom Table Cell
// 
final class RepoTableViewCell: UITableViewCell {
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            self.titleLabel,
            self.descriptionLabel
            ])
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .leading
        view.spacing = 2
        view.accessibilityActivate()
        return view
    }()
    
    var viewModel = RepoViewModel(dataManager: .shared)
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = MDCTypography.titleFont()
        label.accessibilityActivate()
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.gray
        label.font = MDCTypography.body1Font()
        label.accessibilityActivate()
        label.numberOfLines = 0
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    private func setupView() {
        selectionStyle = .none
        contentView.addSubview(stackView)
        contentView.addSubview(avatarImageView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        avatarImageView.leadingAnchor.constraint( equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        avatarImageView.widthAnchor.constraint( equalToConstant: 50).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        stackView.leadingAnchor.constraint( equalTo: avatarImageView.trailingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint( equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
    }
    
    func configure(repo: Repository) {
        titleLabel.text = repo.name
        descriptionLabel.text = repo.description
        
        viewModel.requestImage(urlString: repo.owner?.avatarUrl ?? "") { (image) in
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }
    }
}
