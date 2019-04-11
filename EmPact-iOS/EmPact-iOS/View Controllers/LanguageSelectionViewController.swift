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

        googleMapsController.fetchServiceDistance(40.6655101, -73.89188969999998, 40.6905615, -73.9976592) { (error) in
            if let error = error {
                print("Error fetching distance to chosen service: \(error)")
            }
            
            guard let unwrappedDistance = self.googleMapsController.serviceDistance,
            let unwrappedDuration = self.googleMapsController.serviceTravelDuration else { return }
            
            print("serviceDistance: \(String(describing: unwrappedDistance))")
            print("serviceTravelDuration: \(String(describing: unwrappedDuration))")
        }
        
    }
    
    
    @IBAction func englishButtonClicked(_ sender: Any) {
        
    }
    
    
    @IBAction func espanolButtonClicked(_ sender: Any) {
        
    }
    
}
