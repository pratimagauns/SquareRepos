//
//  BaseViewController.swift
//  SquareRepos
//
//  Created by Pratima Gauns on 9/16/19.
//  Copyright © 2019 Pratima. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents.MDCAppBar
import MaterialComponents.MaterialSnackbar

class BaseViewController: UIViewController {
    let appBar = MDCAppBar()
    let heroHeaderView = HeaderView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        addChild(appBar.headerViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addChild(appBar.headerViewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupHeaderView(isExpanded: Bool) {
        view.backgroundColor = .white
       
        appBar.headerViewController.view.frame = view.bounds
        
        appBar.navigationBar.backgroundColor = .clear
        appBar.navigationBar.title = nil
        view.addSubview(appBar.headerViewController.view)
        appBar.headerViewController.didMove(toParent: self)
        let headerView = appBar.headerViewController.headerView
        headerView.backgroundColor = .clear
        headerView.maximumHeight = isExpanded ? Constants.maxHeight: Constants.minHeight
        headerView.minimumHeight = Constants.minHeight
        
        heroHeaderView.frame = headerView.bounds
        headerView.insertSubview(heroHeaderView, at: 0)
        
        appBar.addSubviewsToParent()
    }
}
