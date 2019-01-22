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
    
    //MARK: Public methods
    func fetchAllData(completion: @escaping (_ data: [String: Any]) -> Void) {
        let request = ["request": RequestType.FETCH_ALL.rawValue]
        self.sendRequest(dataDict: request, completion: completion)
    }
    
    func updateDB(completion: @escaping (_ data: [String: Any]) -> Void) {
        let model = Model.shared
        let objects: [DrinkObject]? = model.entityManager.fetchAll(type: DrinkObject.self)
        guard let cdObjects = objects else {
            completion(["status": "error"])
            return
        }
        
        var values: [String: String] = [:]
        for o in cdObjects {
            values[o.id ?? ""] = o.fingerprint ?? ""
        }
        
        let dataDict = ["request": RequestType.FETCH_ALL.rawValue, "data": values] as [String : Any]
        sendRequest(dataDict: dataDict, completion: completion)
    }
    
    
    //MARK: Private methods
    private func sendRequest(dataDict: [String: Any], completion: @escaping ([String: Any]) -> Void) {
        var request = URLRequest(url: self.defaultURL)
        request.httpMethod = "POST"
        request.httpBody = toJson(dataDict)!
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            let resp : HTTPURLResponse = response as! HTTPURLResponse
            print("All headers....", resp.allHeaderFields)
            
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                completion(["status": "error"])
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                completion(["status": "error"])
            }
            
            let responseString = String(data: data, encoding: .utf8)!
            var dict = self.fromJson(data)
            dict["status"] = "ok"
            print("responseString = \(responseString)")
            completion(dict)
        }
        task.resume()
    }
    
    private func toJson(_ data: [String: Any]) -> Data? {
        do {
            let json = try JSONSerialization.data(withJSONObject: data)
            return json
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func fromJson(_ data: Data) -> [String: Any] {
        guard let stringData = String(data: data, encoding: .utf8) else { return [:] }
        guard let jsonData = stringData.data(using: .utf8) else { return [:] }
        
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
