//
//  RepoViewModel.swift
//  SquareRepos
//
//  Created by Pratima on 12/09/19.
//  Copyright © 2019 Pratima. All rights reserved.
//

import Foundation
import RxSwift

class RepoViewModel {
    public enum HomeError {
        case internetError(String)
        case serverMessage(String)
    }
    
    public let repositories : PublishSubject<[Repository]> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<String> = PublishSubject()
    
    private let disposable = DisposeBag()
    
    public func requestData(){
        self.loading.onNext(true)
        
        DataManager.shared.fetch { (repositories, error)  in
            self.loading.onNext(false)
            if let result = repositories {
                if result.count > 0 {
                    self.repositories.onNext(result)
                }
                else {
                    self.error.onNext(NSLocalizedString("No records.", comment: "Error"))
                }
            }
            else if let error = error {
                switch error {
                case .connectionError:
                    self.error.onNext(NSLocalizedString("No network Connection.", comment: "Error"))
                default:
                    self.error.onNext(NSLocalizedString("Error occurred while fetching data. Please try later", comment: "Error"))
                }
            }
        }
    }
}
