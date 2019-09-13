//
//  RepoTableViewCell.swift
//  SquareRepos
//
//  Created by Pratima on 12/09/19.
//  Copyright © 2019 Pratima. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTypography

extension UIView {
    func addSubView(view: UIView) {
        
    }
}
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
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textColor = UIColor.gray
        label.font = MDCTypography.titleFont()
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textColor = UIColor.gray
        label.font = MDCTypography.body1Font()
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
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.leadingAnchor.constraint( equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint( equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
    }
    
    func configure(repo: Repository) {
        titleLabel.text = repo.name
        descriptionLabel.text = repo.description
    }
}
