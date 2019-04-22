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
    
    override func viewDidAppear(_ animated: Bool) {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
            self.performSegue(withIdentifier: Navigation.toBattleQuizVC.rawValue, sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard outcome != nil else {
            self.view.backgroundColor = negativeOutcome
            self.outcomeLabel.text = "An error occured"
            return
        }
        switch outcome! {
        case .win:
            self.view.backgroundColor = positiveOutcome
        case .tie:
            self.view.backgroundColor = evenOutcome
        case .loose:
            self.view.backgroundColor = negativeOutcome
        default:
            return
        }
        self.outcomeLabel.text = self.outcome!.rawValue

    }
    
    

}
