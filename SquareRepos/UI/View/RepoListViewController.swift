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
class RepoListViewController: BaseViewController {

    let cellIdentifier = "RepoTableCell"
    var viewModel = RepoViewModel(dataManager: DataManager.shared)
    let disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.bounces = false
        tableView.contentInset = .zero
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.delegate = self
//        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(RepoTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        return tableView
    }()
    
    private lazy var activityIndicator: MDCActivityIndicator = {
        let activityIndicator = MDCActivityIndicator()
        activityIndicator.sizeToFit()
        return activityIndicator
    }()
    
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
        
        setupHeaderView(isExpanded: true)

        appBar.headerViewController.layoutDelegate = self
        appBar.headerViewController.headerView.trackingScrollView = tableView
        
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
            .bind(to: tableView
                .rx
                .items(cellIdentifier: cellIdentifier,
                       cellType: RepoTableViewCell.self)) { row, repo, cell in
                        cell.configure(repo: repo)
            }.disposed(by: disposeBag)
        
        tableView
            .rx
            .modelSelected(Repository.self)
            .subscribe(onNext: { [unowned self] repo in
                self.presentRepoDetailsView(repo: repo)
            })
            .disposed(by: disposeBag)
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext:{ (result) in
//                self.repositories.removeAll()
//                self.repositories.append(contentsOf:result)
//                self.tableView.reloadData()
//            })
//            .disposed(by: disposeBag)
        
    }
}

//extension RepoListViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return repositories.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: RepoTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RepoTableViewCell
//        cell.configure(repo: repositories[indexPath.row])
//        cell.isAccessibilityElement = false
//        return cell
//    }
//}

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
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        if let repoDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "RepoDetailsViewController") as? RepoDetailsViewController {
//            repoDetailsViewController.htmlUrl = repositories[indexPath.row].htmlUrl
//            self.present(repoDetailsViewController, animated: true, completion: nil)
//        }
//    }
}

extension RepoListViewController: MDCFlexibleHeaderViewLayoutDelegate {
    public func flexibleHeaderViewController(_ flexibleHeaderViewController: MDCFlexibleHeaderViewController, flexibleHeaderViewFrameDidChange flexibleHeaderView: MDCFlexibleHeaderView) {
        heroHeaderView.update(withScrollPhasePercentage: flexibleHeaderView.scrollPhasePercentage)
    }
}

extension RepoListViewController {
    func presentRepoDetailsView(repo: Repository) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let repoDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "RepoDetailsViewController") as? RepoDetailsViewController {
            repoDetailsViewController.htmlUrl = repo.htmlUrl
            self.present(repoDetailsViewController, animated: true, completion: nil)
        }
    }
}

