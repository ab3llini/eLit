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
    // Default completion handler for update db request
    let defaultUdateDbHandler: (_: [String: Any]) -> Void = { response in
        
        let updatedObjectsList = response["data"] as? [[String: Any]] ?? []
        let model = Model.shared
        let idsToUpdate = updatedObjectsList.map({ dict in
            return dict["id"] as? String ?? ""
        })
            
        // Updating exsisting objects
        var currentObjects: [DrinkObject]? = EntityManager.shared.fetchAll(type: DrinkObject.self)
        let currentIds = currentObjects?.map({ (obj: DrinkObject) in
            return obj.id ?? ""
        }) ?? []
        currentObjects = currentObjects?.filter {idsToUpdate.contains($0.id ?? "")}
        
        for updatedObject in updatedObjectsList {
            let toUpdateList = currentObjects?.filter { ($0.id ?? "") == (updatedObject["id"] as? String ?? "") }
            if let toUpdate = toUpdateList?.first {
                toUpdate.update(with: updatedObject)
            }
        }
        
        // Creating new objects
        let newObjectList = updatedObjectsList.filter { !(currentIds.contains($0["id"] as? String ?? "")) }
        
        for obj in newObjectList {
            switch obj["cls"] as! String {
            case "Ingredient":
                let _ = Ingredient(dict: obj)
            case "DrinkComponent":
                let _ = DrinkComponent(dict: obj)
            case "RecipeStep":
                let _ = RecipeStep(dict: obj)
            case "Recipe":
                let _ = Recipe(dict: obj)
            case "DrinkCategory":
                break
                //let _ = DrinkCategory(dict: obj)
            default:
                let _ = Drink(dict: obj)
            }
        }
        
        
        // Saving the model
        model.reloadDrinks()
        model.savePersistentModel()
    }
    
    //MARK: Initializers
    private override init() {
        self.defaultURL = URL(string: Preferences.shared.coreSettings.host)!
    }
    
    //MARK: Public methods
    
/**
 This method will create a request for getting all the drinks from the main db
 
 - Parameter completion: the function that will be called after the response, it takes as input the data dictionary with all the informations about the drinks. It has also a key "status" that is "ok" if the request succeded and "error" if something went wrong
 **/
    func fetchAllData(completion: @escaping (_ data: [String: Any]) -> Void) {
        self.sendRequest(for: .FETCH_ALL, with: [:], completion: completion)
    }
    
    
/**
 This method will create a dictionary with all ids and fingerprints of the objects in the db and will request an update of the drinks that have been changed in the main DB
 
 - Parameter comletion: the function that will be called after the response, it takes as input the data dictionary with all the informations about the modified drinks. It has also a key "status" that is "ok" if the request succeded and "error" if something went wrong
 **/
    func updateDB(completion: @escaping ((_ data: [String: Any]) -> Void) = DataBaseManager.shared.defaultUdateDbHandler) {
        
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
        
        sendRequest(for: .UPDATE_DB, with: values, completion: completion)
    }
    
    
/**
 This method will send a request to the main DB for register the user
 
 - Parameter user: is the new user to register
 - Parameter completion: function called after the response
 **/
    func signInUser(user: User, completion: @escaping (_ data: [String: Any]) -> Void) {
        self.sendRequest(for: .USER_SIGN_IN, with: user.toDict(), completion: completion)
    }
    
/**
     This method will send a request to the DB for fetching a batch of reviews for a specific drink
     - Parameter drink: is the drink for the reviews
     - Parameter index: is the next index for fetching the reviews
     - Parameter completion: is the callback function to call when the response arrives
 **/
    func requestReviews(for drink: Drink, from index: Int, completion: @escaping (_ data: [String: Any]) -> Void) {
        let request: [String: Any] = [
            "drink_id": drink.id ?? "0",
            "from_index": index] as [String: Any]
        
        self.sendRequest(for: .FETCH_REVIEWS, with: request, completion: completion)
    }
    
    
    func requestReview(for drink: Drink, from userID: String, completion: @escaping (_ data: [String: Any]) -> Void) {
        let request: [String: Any] = [
            "drink_id": drink.id ?? "0",
            "from_user": userID] as [String: Any]
        self.sendRequest(for: .FETCH_REVIEW, with: request, completion: completion)
    }
    
    /**
     This method will send a request to the DB to add a review for specific drink
     - Parameter drink: is the drink for the reviews
     - Parameter rating: the rating of the review (0--5)
     - Parameter title: the title of the review
     - Parameter content: the content of the review
     - Parameter completion: is the callback function to call when the response arrives
     **/
    func addNewReview(for drink: Drink, rating : Int, title : String, content : String, completion: @escaping (_ data: [String: Any]) -> Void) {
        let request: [String: Any] = [
            "user_id": Model.shared.user?.userID ?? "Not authenticated!",
            "drink_id": drink.id ?? "",
            "rating" : rating,
            "title" : title,
            "content" : content] as [String: Any]
        
        self.sendRequest(for: .ADD_REVIEW, with: request, completion: completion)
    }
    
    /**
     This method will send a request to the DB for fetching a batch of reviews for a specific drink
     - Parameter drink: is the drink for the reviews
     - Parameter index: is the next index for fetching the reviews
     - Parameter completion: is the callback function to call when the response arrives
     **/
    func requestCategories(completion: @escaping (_ data: [String: Any]) -> Void) {
        let request: [String: Any] = [:]
        
        self.sendRequest(for: .FETCH_CATEGORIES, with: request, completion: completion)
    }
    
/**
     This method will send a request to the main DB for getting the rating for a specific drink
     - Parameter drink: is the drink for which we are asking the rating
     - Parameter completion: is the callback function called when the response arrives
 **/
    func requestRating(for drink: Drink, completion: @escaping (_ data: [String: Any]) -> Void) {
        let request: [String: Any] = ["drink_id": drink.id ?? "0"]
        
        self.sendRequest(for: .RATING, with: request, completion: completion)
    }
    
    func searchIngredient(for barcode: String, completion: @escaping (String?) -> Void) {
        let baseURL = "https://world.openfoodfacts.org/api/v0/product/"
        let url = URL(string: baseURL + barcode)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        print("Sending request to \(url?.absoluteString)")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let _ : HTTPURLResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    
                }
                return
            }
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            var dict = self.fromJson(data)
            let product = dict["product"] as? [String: Any] ?? [:]
            let productName = product["product_name"] as? String ?? nil
            if productName == nil {
                let url = URL(string: "https://api.upcitemdb.com/prod/trial/lookup?upc=" + barcode)
                var request = URLRequest(url: url!)
                request.httpMethod = "GET"
                print("Sending request to \(url?.absoluteString)")
                
                let backupTask = URLSession.shared.dataTask(with: request) { data, response, error in
                    
                    guard let _ : HTTPURLResponse = response as? HTTPURLResponse else {
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                        return
                    }
                    
                    guard let data = data, error == nil else {
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                        return
                    }
                    
                    var dict = self.fromJson(data)
                    let product = dict["items"] as? [[String: Any]] ?? []
                    let productName = product.first?["title"] as? String ?? nil
                        DispatchQueue.main.async {
                            completion(productName)
                        }
                }
                backupTask.resume()
                
            } else {
                DispatchQueue.main.async {
                    completion(productName)
                }
            }
        }
        task.resume()
    }
    
    
    //MARK: Private methods
    
/**
 This method will send a POST request to the main DB
 
 - Parameter dataDict: is a dictionary that contains the request type as agument for the key "request" and all the necessary data with the key "data".
 
 - Parameter completion: is the function that will be called after the request is completed. As input will be passed the data dictionary that comes from the server with a "status" key that will be "ok" if the request succeded otherwhise "error"
 **/
    private func sendRequest(for requestType: RequestType, with dataDict: [String: Any], completion: @escaping ([String: Any]) -> Void) {
        var request = URLRequest(url: self.defaultURL)
        request.httpMethod = "POST"
        let data = ["request": requestType.rawValue, "data": dataDict] as [String : Any]
        request.httpBody = toJson(data)!
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let _ : HTTPURLResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(["status": "error"])
                }
                return
            }
            
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                NSLog("error=\(String(describing: error))")
                DispatchQueue.main.async {
                    completion(["status": "error"])
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                DispatchQueue.main.async {
                    completion(["status": "error"])
                }
                return
            }
            
            var dict = self.fromJson(data)
            dict["status"] = "ok"
            DispatchQueue.main.async {
                completion(dict)
            }
            
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
            return dictData
        } catch {
            return [:]
        }
    }

}
