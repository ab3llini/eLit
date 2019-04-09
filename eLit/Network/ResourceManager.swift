//
//  ResourceManager.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 08/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

typealias CompletionHandler<T>  = (_ result: T) -> Void

class ResourceManager: NSObject {
    
    // MARK: attributes
    public static let shared = ResourceManager()
    public static let defaultImagePlaceholder = UIImage(named: "drink_placeholder")!
    
    private var completion_map = Dictionary<String, [CompletionHandler<Data?>]>()
    private var dataMap = Dictionary<String, Data?>()
    private let serialQueue = DispatchQueue(label: "completions")
    
    
    public func fetchImageData(from relativeURL : String, onCompletion handler : @escaping CompletionHandler<Data?>) {
        if let completions = self.completion_map[relativeURL] {
            // The image has already been requested
            
            if completions.isEmpty {
                // I already have the data, just call the completion
                callCompletion(with: self.dataMap[relativeURL]!, handler)
            } else {
                completion_map[relativeURL]?.append(handler)
            }
            
        } else {
            // The image has to be requested
            guard let url = URL(string: Preferences.shared.coreSettings.host + relativeURL) else {
                callCompletion(with: nil, handler)
                return
            }
            
            // Requesting the image...
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                guard let data = data, error == nil else {
                    // check for fundamental networking error
                    NSLog("error=\(String(describing: error))")
                    self.callAllCompletions(with: nil, for: relativeURL)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    self.callAllCompletions(with: nil, for: relativeURL)
                }
                else {
                    self.dataMap[relativeURL] = data
                    self.callAllCompletions(with: data, for: relativeURL)
                }
            }.resume()
        }
    }
    
    private func callCompletion(with data: Data?, _ completion: @escaping CompletionHandler<Data?>) {
        DispatchQueue.main.async {
            completion(data)
        }
    }
    
    private func callAllCompletions(with data: Data?, for url: String) {
        guard let d = self.dataMap[url], var completions = self.completion_map[url] else {
            return
        }
        
        self.serialQueue.sync {
            self.completion_map[url] = []
        }
        
        while !completions.isEmpty {
            let completion = completions.remove(at: 0)
            completion(d)
        }
    }
}
