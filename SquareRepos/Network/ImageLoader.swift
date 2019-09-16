//
//  ImageCaching.swift
//  SquareRepos
//
//  Created by Pratima Gauns on 9/16/19.
//  Copyright © 2019 Pratima. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol ImageCaching {
    func save(image: UIImage?, url: URL)
    func get(url: URL) -> UIImage?
}

class ImageCache: ImageCaching {
    var cacheDictionary = Dictionary<String, UIImage>()
    
    func save(image: UIImage?, url: URL) {
        if let image = image {
            cacheDictionary[url.absoluteString] = image
        }
    }
    
    func get(url: URL) -> UIImage? {
        return cacheDictionary[url.absoluteString]
    }
}

class ImageLoader {
    func executeRequest(requestUrl: URL, completion: @escaping (UIImage?)-> Void) {
        let task = URLSession.shared.dataTask(with: requestUrl) {
            (data, response, error) in
            if let _ = data {
                completion(UIImage(data: data!))
            }
            else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func rxImage(url: URL, cache: ImageCaching, completion: @escaping (UIImage?)-> Void) {
        if let image = cache.get(url: url) {
            completion(image)
        }
        else {
            self.executeRequest(requestUrl: url, completion: { (img) in
                if let image = img {
                    cache.save(image: image, url: url)
                    completion(image)
                }
                else {
                    //error
                    completion(nil)
                }
            })
        }
    }
    
    func rxImage(url: URL, completion: @escaping (UIImage?)-> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        rxImage(url: url, cache: appDelegate.imageCache, completion: completion)
    }
}

extension ImageLoader {
    
    private static var _shared: ImageLoader?
    
    public static let shared: ImageLoader = {
        guard let instance = _shared else {
            return ImageLoader()
        }
        return instance
    }()
    
    public class func initializeShared(_ instance: ImageLoader) {
        _shared = instance
    }
}
