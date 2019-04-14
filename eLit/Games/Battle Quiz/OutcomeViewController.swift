//
//  GameOutcomeViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 14/04/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit


class OutcomeViewController: UIViewController {

    @IBOutlet weak var outcomeLabel: UILabel!
    
    @IBInspectable var positiveOutcome : UIColor = .blue
    @IBInspectable var negativeOutcome : UIColor = .yellow
    @IBInspectable var evenOutcome : UIColor = .green
    
    public var outcome : GameOutcome?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard outcome != nil else { return }
        self.outcomeLabel.text = self.outcome!.rawValue
    }
    
    

}
