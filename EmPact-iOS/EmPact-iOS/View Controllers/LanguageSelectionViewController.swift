//
//  LanguageSelectionViewController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/28/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class LanguageSelectionViewController: UIViewController {

    let googleMapsController = GoogleMapsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTheme()
    }
    
    @IBAction func englishButtonClicked(_ sender: Any) {
        
    }
    
    
    @IBAction func espanolButtonClicked(_ sender: Any) {
        
    }
    
    func setupTheme() {
        
        self.navigationController?.navigationBar.barTintColor = .customDarkPurple
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
}
