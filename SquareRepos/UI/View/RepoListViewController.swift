//
//  ViewController.swift
//  SquareRepos
//
//  Created by Pratima on 11/09/19.
//  Copyright © 2019 Pratima. All rights reserved.
//

import UIKit
import RxSwift
import MaterialComponents.MDCAppBar
import MaterialComponents.MaterialSnackbar

// 
// View - VC that displays the list data
// 
class RepoListViewController: UIViewController {

    let cellIdentifier = "RepoTableCell"
    var viewModel = RepoViewModel(dataManager: DataManager.shared)
    let disposeBag = DisposeBag()
    var repositories = [Repository]()
    let appBar = MDCAppBar()
    let heroHeaderView = HeaderView()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.bounces = false
        tableView.contentInset = .zero
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.accessibilityActivate()
        tableView.register(RepoTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        return tableView
    }()
    
    private lazy var activityIndicator: MDCActivityIndicator = {
        let activityIndicator = MDCActivityIndicator()
        activityIndicator.sizeToFit()
        return activityIndicator
    }()
    
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
        self.setupView()
        self.setupBindings()
        viewModel.requestData()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.leadingAnchor.constraint( equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint( equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        appBar.headerViewController.view.frame = view.bounds
        
        appBar.navigationBar.backgroundColor = .clear
        appBar.navigationBar.title = nil
        view.addSubview(appBar.headerViewController.view)
        appBar.headerViewController.didMove(toParent: self)
        appBar.headerViewController.layoutDelegate = self
        let headerView = appBar.headerViewController.headerView
        headerView.backgroundColor = .clear
        headerView.maximumHeight = HeaderView.Constants.maxHeight
        headerView.minimumHeight = HeaderView.Constants.minHeight
        
        heroHeaderView.frame = headerView.bounds
        headerView.insertSubview(heroHeaderView, at: 0)
        
        appBar.headerViewController.headerView.trackingScrollView = tableView
        appBar.addSubviewsToParent()
        
        self.activityIndicator.center = self.view.center;
        self.view.addSubview(self.activityIndicator)
    }
    
    private func setupBindings() {
        viewModel.loading
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ (bool) in
                if bool {
                    self.activityIndicator.startAnimating()
                }
                else {
                    self.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel
            .error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (error) in
                let message = MDCSnackbarMessage()
                message.text = error
                MDCSnackbarManager.show(message)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .repositories
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ (result) in
                self.repositories.removeAll()
                self.repositories.append(contentsOf:result)
                self.tableView.reloadData()
                print("Data Fetched")
            })
            .disposed(by: disposeBag)
        
    }
}

extension RepoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RepoTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RepoTableViewCell
        cell.configure(repo: repositories[indexPath.row])
        return cell
    }
}

extension RepoListViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = appBar.headerViewController.headerView
        if scrollView == headerView.trackingScrollView {
            headerView.trackingScrollDidScroll()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let headerView = appBar.headerViewController.headerView
        if scrollView == headerView.trackingScrollView {
            headerView.trackingScrollDidEndDecelerating()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let headerView = appBar.headerViewController.headerView
        if scrollView == headerView.trackingScrollView {
            headerView.trackingScrollDidEndDraggingWillDecelerate(decelerate)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let headerView = appBar.headerViewController.headerView
        if scrollView == headerView.trackingScrollView {
            headerView.trackingScrollWillEndDragging(withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
    }
}

extension RepoListViewController: MDCFlexibleHeaderViewLayoutDelegate {
    public func flexibleHeaderViewController(_ flexibleHeaderViewController: MDCFlexibleHeaderViewController, flexibleHeaderViewFrameDidChange flexibleHeaderView: MDCFlexibleHeaderView) {
        heroHeaderView.update(withScrollPhasePercentage: flexibleHeaderView.scrollPhasePercentage)
    }
}

