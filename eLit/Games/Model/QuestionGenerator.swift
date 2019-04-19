//
//  QuestionGenerator.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 15/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit

struct Question {
    var question: String?
    var answers: [String: Bool]?
    var image: UIImage?
    var timeout: Int = 10
    
    init(question: String?, answers: [String: Bool]?, image: UIImage?) {
        self.question = question
        self.answers = answers
        self.image = image
    }
}

class QuestionGenerator: NSObject {
    
    let drinks = Model.shared.getDrinks()
    let ingredients = Model.shared.getIngredients()
    
    func getQuestion() -> Question {
        if Float.random(in: 0...1) < 0.5 {
            return generateQuestion(for: self.drinks.randomElement()!)
        }
        return generateQuestion(for: self.ingredients.randomElement()!)
    }
    
    func generateQuestion(for drink: Drink) -> Question {
        var q = Question(question: nil, answers: nil, image: nil)
        drink.getImage(completion: { image in
            q.image = image
        })
        var answers: [String: Bool] = [:]
        let drinkIngredients = drink.ingredients().filter({$0.name != "Ice"})
        let question = "Which of the following ingredients is present in \(drink.name!)?"
        let answer1 = drinkIngredients.randomElement()!.name!
        answers[answer1] = true
        
        let allIngredients = Model.shared.getIngredients()
        var ingrediets = allIngredients.filter({ingredient in
            if drink.ingredients().map({$0.name}).contains(ingredient.name) {
                return false
            }
            return true
        })
        
        for _ in 0..<3 {
            let ing = ingrediets.randomElement()!
            ingrediets.removeAll(where: {$0.name == ing.name})
            answers[ing.name!] = false
        }
        
        q.question = question
        
        return q
    }
    
    func generateQuestion(for ingredient: Ingredient) -> Question {
        var q = Question(question: nil, answers: nil, image: nil)
        ingredient.getImage(completion: {image in
            q.image = image
        })
        let question = "In which of the following drinks is \(ingredient.name!) present?"
        var allDrinks = Model.shared.getDrinks()
        let idx = allDrinks.partition(by: {drink in
            drink.ingredients().map({$0.name!}).contains(ingredient.name!)
        })
        
        var correctAnswers = allDrinks[idx...]
        var wrongAnswers = allDrinks[..<idx]
        
        var answers: [String: Bool] = [:]
        
        if idx < 3 {
            let answer1 = "All of them"
            answers[answer1] = true
            
            for _ in 0..<3 {
                let d = correctAnswers.randomElement()!
                correctAnswers.removeAll(where: {$0.name! == d.name!})
                answers[d.name!] = false
            }
        } else {
            let answer1 = correctAnswers.randomElement()!.name!
            
            answers[answer1] = true
            
            for _ in 0..<3 {
                let d = wrongAnswers.randomElement()!
                wrongAnswers.removeAll(where: {$0.name! == d.name!})
                answers[d.name!] = false
            }
        }
        
        q.question = question
        
        return q
    }

}
