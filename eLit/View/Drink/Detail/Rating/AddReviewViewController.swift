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
        self.drink.setImageAndColor { (image, color) in
            self.setBackgroundImage(image, withColor: color)
        }
        
        DataBaseManager.shared.requestReview(for: drink, from: Model.shared.user?.userID ?? "", completion: { data in
            guard (data["status"] as! String) == "ok" else { return }
            let d = data["data"] as! [String: Any]
            self.reviewTitle.text = d["title"] as? String ?? ""
            self.reviewContent.text = d["text"] as? String ?? ""
            self.ratingView.rating = d["rating"] as? Double ?? 0.0
        })
    }
    
    func onReviewSubmitted(response : [String : Any]) -> Void {
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
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
    
    
        self.present(alert, animated: true)
        
    }
    
    @objc func submitReview() {
        
        
        if ((reviewTitle.text?.count ?? 0) >= 5) {
            

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
