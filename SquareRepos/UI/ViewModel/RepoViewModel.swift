//
//  RepoViewModel.swift
//  SquareRepos
//
//  Created by Pratima on 12/09/19.
//  Copyright © 2019 Pratima. All rights reserved.
//

import Foundation
import RxSwift

//
// View Model that forms a link between the Repository List VC and the Model
//
class RepoViewModel {
    
    public let repositories : PublishSubject<[Repository]> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<String> = PublishSubject()
    
    private let disposable = DisposeBag()
    
    var dataManager = DataManager.shared
    
    public init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    public func requestData(){
        self.loading.onNext(true)
        
        dataManager.fetch { (repositories, error)  in
            self.loading.onNext(false)
            if let result = repositories {
                if result.count > 0 {
                    self.repositories.onNext(result)
                }
                else {
                    self.error.onNext(NSLocalizedString("Error.no_records", comment: "Error"))
                }
            }
            else if let error = error {
                switch error {
                case .connectionError:
                    self.error.onNext(NSLocalizedString("Error.no.connection", comment: "Error"))
                default:
                    self.error.onNext(NSLocalizedString("Error.service.error", comment: "Error"))
                }
            }
        }
    }
    
    public func requestImage(urlString: String, completion: @escaping (UIImage?)-> Void){
        guard let url = URL(string: urlString) else {
            completion(UIImage(named: "Logo")!)
            return
        }
        ImageLoader.shared.rxImage(url: url) { (image) in
            if let _ = image {
                completion(image!)
            }
            else {
                completion(UIImage(named: "Logo")!)
            }
        }
    }
}
