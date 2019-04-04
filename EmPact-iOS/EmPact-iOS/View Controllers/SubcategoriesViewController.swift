//
//  SubcategoriesViewController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 4/3/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class SubcategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let networkController = NetworkController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkController.fetchSubcategoriesNames(SubCategory.shelters) { (error) in
            
            if let error = error {
                NSLog("Error fetching categories: \(error)")
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkController.subcategoryNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subcategoryNameCell", for: indexPath)
        
        cell.textLabel?.text = networkController.subcategoryNames[indexPath.row].uppercased()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
}
