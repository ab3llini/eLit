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
    
    public static let shared = ResourceManager()
    
    public func fetchImageData(from relativeURL : String, onCompletion handler : CompletionHandler<NSData>) {
    
        //URL(string: Preferences.shared.coreSettings.host + self.imageURLString!) else {

    }
}
