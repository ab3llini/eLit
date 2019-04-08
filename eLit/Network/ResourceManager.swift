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
    private var completion_map = Dictionary<String, [CompletionHandler<Data?>]>()
    private var dataMap = Dictionary<String, Data?>()
    
    
    public func fetchImageData(from relativeURL : String, onCompletion handler : @escaping CompletionHandler<Data?>) {
        if let completions = self.completion_map[relativeURL] {
            // The image has already been requested
            
            if completions.isEmpty {
                // I already have the data, just call the completion
                DispatchQueue.main.async {
                    handler(self.dataMap[relativeURL]!)
                }
            }
            completion_map[relativeURL]?.append(handler)
        } else {
            // The image has to be requested
        }
    
        //URL(string: Preferences.shared.coreSettings.host + self.imageURLString!) else {

    }
}
