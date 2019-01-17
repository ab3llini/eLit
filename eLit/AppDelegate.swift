//
//  AppDelegate.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 22/12/2018.
//  Copyright © 2018 Alberto Mario Bellini. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        /*
        var drinks = Model.getInstance().getDrinks()
        drinks.forEach { d in print(d) }
        
        let ingredient = Ingredient(name: "testIngredient")
        let ingredient2 = Ingredient(name: "testIngredient2")
        let component = DrinkComponent(ingredient: ingredient, quantity: 2, unit: .PART)
        let component2 = DrinkComponent(ingredient: ingredient2, quantity: 4, unit: .PART)
        let step = RecipeStep(drinkComponents: [component])
        let step2 = RecipeStep(drinkComponents: [component, component2])
        let recipe = Recipe(steps: [step, step2])
 
        
        let model = Model.shared as Model
        
        let drink1 = Drink(name: "Drink1", image: "Drink1", degree: 25)
        let drink2 = Drink(name: "Drink2", image: "Drink2", degree: 35)
        let drink3 = Drink(name: "Drink3", image: "Drink3", degree: 20)
        let drink4 = Drink(name: "Drink4", image: "Drink4", degree: 40)
        
        model.addDrink(drink1)
        model.addDrink(drink2)
        model.addDrink(drink3)
        model.addDrink(drink4)
        
        let dbManager = DataBaseManager.shared
        _ = dbManager.fetchAllData() { print($0) }
        
        
        //model.savePersistentModel()
         */
        
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack
    
    //TODO: - MOVE THIS 2 METHODS IN THE MODEL IMPLEMENTATION!!!! 
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "eLit")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

