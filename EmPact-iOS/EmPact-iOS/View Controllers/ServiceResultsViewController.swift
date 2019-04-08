//
//  ServiceResultsViewController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/29/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class ServiceResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBarView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var subcategoriesTitleLabel: UILabel!
    
    var selectedSubcategory: String!
    
    var networkController: NetworkController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let passedSubCategory = selectedSubcategory.lowercased()
        
        networkController?.fetchSubcategoryDetails(passedSubCategory) { (error) in
            
            if let error = error {
                NSLog("Error fetching categories: \(error)")
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkController?.subcategoryDetails.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ServiceResultTableViewCell.reuseIdentifier, for: indexPath) as! ServiceResultTableViewCell
        
        let subcategoryDetail = networkController?.subcategoryDetails[indexPath.row]
        cell.serviceNameLabel.text = subcategoryDetail?.name
        cell.serviceAddressLabel.text = subcategoryDetail?.address
        cell.servicePhoneLabel.text = subcategoryDetail?.phone
        cell.serviceHoursLabel.text = subcategoryDetail?.hours
            
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
