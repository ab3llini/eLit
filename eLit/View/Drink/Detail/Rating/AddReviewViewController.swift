//
//  AddReviewViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 14/02/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import Cosmos

class AddReviewViewController: BlurredBackgroundViewController {

    @IBOutlet weak var reviewContentPlaceholder: UITextField!
    @IBOutlet weak var reviewContent: ReviewTextView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var reviewTitle: UITextField!
    
    var drink : Drink!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add right button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(submitReview))
        

        // Do any additional setup after loading the view.
        self.reviewContent.placeholder = reviewContentPlaceholder
        
        // Setupd bg image
        self.setBackgroundImage(self.drink.image, withColor: Renderer.shared.getDrinkCoreColors()[self.drink.name!]!)
    }
    
    func onReviewSubmitted(response : [String : Any]) -> Void {
        
        DispatchQueue.main.async {
        
            var title, content : String
            
            if response["status"] as? String ?? "" == "ok" {
                
                title = "Thanks!"
                content = "Your review has been submitted."
                
            }
            else {
                
                title = "Oops"
                content = "Something went wrong, try again later."
                
            }
            
            let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        
            self.present(alert, animated: true)
            
        }
        
    }
    
    @objc func submitReview() {
        
        
        if (reviewTitle.text!.count >= 5) {
            

            DataBaseManager.shared.addNewReview(
                for: self.drink,
                rating: Int(ratingView.rating),
                title: reviewTitle.text ?? "No title",
                content: reviewContent.text ?? "No content",
                completion: self.onReviewSubmitted
            )
            
        }
        else {
            
            let alert = UIAlertController(title: "Be generous!", message: "Title should be at least five characters long.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
        }
        
    }
    

}
