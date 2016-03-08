//
//  StartGameViewController.swift
//  GifJams
//
//  Created by Christian Gonzalez on 1/28/16.
//  Copyright © 2016 Christian Gonzalez. All rights reserved.
//

import Foundation
import UIKit

class StartGameViewController: UIViewController {
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func startGameButton(sender: AnyObject) {
        performSegueWithIdentifier("GamePlaySegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}