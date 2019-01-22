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
    
/**
 This method will create a request for getting all the drinks from the main db
 
 - Parameter completion: the function that will be called after the response, it takes as input the data dictionary with all the informations about the drinks. It has also a key "status" that is "ok" if the request succeded and "error" if something went wrong
 **/
    func fetchAllData(completion: @escaping (_ data: [String: Any]) -> Void) {
        let request = ["request": RequestType.FETCH_ALL.rawValue, "data": nil]
        self.sendRequest(dataDict: request as [String : Any], completion: completion)
    }
    
    
/**
 This method will create a dictionary with all ids and fingerprints of the objects in the db and will request an update of the drinks that have been changed in the main DB
 
 - Parameter comletion: the function that will be called after the response, it takes as input the data dictionary with all the informations about the modified drinks. It has also a key "status" that is "ok" if the request succeded and "error" if something went wrong
 **/
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
    
    
/**
 This method will send a request to the main DB for register the user
 
 - Parameter user: is the new user to register
 - Parameter completion: function called after the response
 **/
    func signInUser(user: User, completion: @escaping (_ data: [String: Any]) -> Void) {
        let request = ["request": RequestType.USER_SIGN_IN.rawValue, "data": user.toDict()] as [String : Any]
        self.sendRequest(dataDict: request, completion: completion)
    }
    
    
    //MARK: Private methods
    
/**
 This method will send a POST request to the main DB
 
 - Parameter dataDict: is a dictionary that contains the request type as agument for the key "request" and all the necessary data with the key "data".
 
 - Parameter completion: is the function that will be called after the request is completed. As input will be passed the data dictionary that comes from the server with a "status" key that will be "ok" if the request succeded otherwhise "error"
 **/
    private func sendRequest(dataDict: [String: Any], completion: @escaping ([String: Any]) -> Void) {
        var request = URLRequest(url: self.defaultURL)
        request.httpMethod = "POST"
        request.httpBody = toJson(dataDict)!
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let resp : HTTPURLResponse = response as? HTTPURLResponse else {
                completion(["status": "error"])
                return
            }
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