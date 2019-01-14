//
//  DataBaseManager.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 13/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit

class DataBaseManager: NSObject {
    //MARK: Attributes
    public static let shared = DataBaseManager()
    private let defaultURL: URL
    
    //MARK: Initializers
    private override init() {
        self.defaultURL = URL(string: "http://127.0.0.1")!
    }
    
    
    //MARK: Methods
    func sendRequest(dataDict: Dictionary<String, Any>) -> String? {
        var request = URLRequest(url: self.defaultURL)
        request.httpMethod = "POST"
        request.httpBody = toJson(dataDict)!
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            let resp : HTTPURLResponse = response as! HTTPURLResponse
            print("All headers....", resp.allHeaderFields)
            
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)!
            let json = self.fromJson(data)
            print("responseString = \(responseString)")
        }
        task.resume()
        return nil
    }
    
    func toJson(_ data: Dictionary<String, Any>) -> Data? {
        do {
            let json = try JSONSerialization.data(withJSONObject: data)
            return json
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fromJson(_ data: Data) -> Dictionary<String, Any> {
        guard let stringData = String(data: data, encoding: .utf8) else { return [:] }
        let jsonStringArray = stringData.split(separator: "{")[1...]
        let jsonString = jsonStringArray.reduce("") { acc, step in
            acc + "{" + step
        }
        print(jsonString)
        
        guard let jsonData = jsonString.data(using: .utf8) else { return [:] }
        
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData)
            let dictData = json as? [String: Any] ?? [:]
            print(dictData)
            return dictData
        } catch {
            return [:]
        }
    }

}
