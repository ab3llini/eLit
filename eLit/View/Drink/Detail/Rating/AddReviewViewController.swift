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

        // Do any additional setup after loading the view.
        self.reviewContent.placeholder = reviewContentPlaceholder
        
        // Setupd bg image
        self.setBackgroundImage(self.drink.image, withColor: Renderer.shared.getCoreColors()[self.drink.name!]!)
    }
    

}
