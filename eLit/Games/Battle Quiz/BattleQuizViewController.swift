//
//  BattleQuizViewController.swift
//  eLit
//
//  Created by Alberto Mario Bellini on 02/03/2019.
//  Copyright © 2019 eLit.app. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class BattleQuizViewController: UITableViewController, MCBrowserViewControllerDelegate {
    
    let mpHandler = MPCHandler.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mpHandler.setupPeer(with: UIDevice.current.name)
        self.mpHandler.setupSession()
        self.mpHandler.advertiseSelf(advertise: true)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func connectWithPlayer(_ sender: Any) {
        if mpHandler.session != nil {
            mpHandler.setupBrowser()
            mpHandler.browser.delegate = self
            
            self.present(mpHandler.browser, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        self.mpHandler.browser.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        self.mpHandler.browser.dismiss(animated: true, completion: nil)
    }

}
