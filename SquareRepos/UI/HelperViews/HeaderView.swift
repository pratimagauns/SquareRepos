//
//  HeaderView.swift
//  SquareRepos
//
//  Created by Pratima on 12/09/19.
//  Copyright © 2019 Pratima. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTypography

// 
// Custom expandable header view
// 
class HeaderView: UIView {
    
    struct Constants {
        static let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        static let minHeight: CGFloat = 44 + statusBarHeight
        static let maxHeight: CGFloat = 150.0
    }
    
    // MARK: Properties
    let backButton: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Button.title.cacel", comment: "AppIcon")
        label.textAlignment = .center
        label.textColor = .white
        label.shadowOffset = CGSize(width: 1, height: 1)
        label.shadowColor = .darkGray
        label.accessibilityActivate()
        return label
    }()
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("List.title", comment: "AppIcon")
        label.textAlignment = .center
        label.textColor = .white
        label.shadowOffset = CGSize(width: 1, height: 1)
        label.shadowColor = .darkGray
        label.accessibilityActivate()
        return label
    }()
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        clipsToBounds = true
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View
    func configureView() {
        backgroundColor = UIColor(red: 26.0/255, green: 141.0/255, blue: 204.0/255, alpha: 1)
        addSubview(titleLabel)
    }
    
    func addBackButton() {
        addSubview(backButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        backButton.frame = CGRect(
            x: frame.width - 100.0,
            y: Constants.statusBarHeight,
            width: 100.0,
            height: 44.0)
    
        titleLabel.frame = CGRect(
            x: 0,
            y: Constants.statusBarHeight,
            width: frame.width,
            height: frame.height - Constants.statusBarHeight)
    }
    
    func update(withScrollPhasePercentage scrollPhasePercentage: CGFloat) {
        let fontSize = scrollPhasePercentage.scaled(from: 0...1, to: 20.0...26.0)
        let font = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.semibold)
        titleLabel.font = font
    }
}

// MARK: Number Utilities - Based on code from https://github.com/raizlabs/swiftilities
extension FloatingPoint {
    public func scaled(from source: ClosedRange<Self>, to destination: ClosedRange<Self>, clamped: Bool = false, reversed: Bool = false) -> Self {
        let destinationStart = reversed ? destination.upperBound : destination.lowerBound
        let destinationEnd = reversed ? destination.lowerBound : destination.upperBound
        
        // these are broken up to speed up compile time
        let selfMinusLower = self - source.lowerBound
        let sourceUpperMinusLower = source.upperBound - source.lowerBound
        let destinationUpperMinusLower = destinationEnd - destinationStart
        var result = (selfMinusLower / sourceUpperMinusLower) * destinationUpperMinusLower + destinationStart
        if clamped {
            result = result.clamped(to: destination)
        }
        return result
    }
}

public extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        return clamped(min: range.lowerBound, max: range.upperBound)
    }
    
    func clamped(min lower: Self, max upper: Self) -> Self {
        return min(max(self, lower), upper)
    }
}
