//
//  CategoriesViewController.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 3/29/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController { // UICollectionViewDelegate, UICollectaionViewDataSource

    override func viewDidLoad() {
        super.viewDidLoad()

        // Make Collection View Outlet
        // Set Delegate
        // Set DataSource
        
        Firebase<Categories>.fetchRecords { (categories) in
            if let categories = categories {
                NSLog("\(categories)")
                
                DispatchQueue.main.async {
                    // reload the table view data
                }
            }
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

    //let firebase = Firebase()
}
