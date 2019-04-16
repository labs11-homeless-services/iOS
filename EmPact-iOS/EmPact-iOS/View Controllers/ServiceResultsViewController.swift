//
//  ServiceResultsViewController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/29/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class ServiceResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBarView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var subcategoriesTitleLabel: UILabel!
    
    @IBAction func unwindToSubcategoriesVC(segue:UIStoryboardSegue) {
        networkController?.subcategoryNames = []
        networkController?.subcategoryDetails = []
        networkController?.tempCategorySelection = ""
        selectedSubcategory = ""
        performSegue(withIdentifier: "unwindToSubcategoriesVC", sender: self)
        
    }
    
    var selectedSubcategory: String!
    
    var networkController: NetworkController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        searchBar.delegate = self
        
        if networkController?.tempCategorySelection == "" {
            self.title = "Search Results"
        } else {
            guard let unwrappedTempCategorySelection = networkController?.tempCategorySelection else { return }
            self.title = "\(unwrappedTempCategorySelection) - \(selectedSubcategory.capitalized)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let unwrappedSubcategoryAtIndexPath = networkController?.subcategoryAtIndexPath else { return }
        if (networkController?.subcategoryDetails.count ?? 0) < 1 {
            networkController?.fetchSubcategoryDetails(unwrappedSubcategoryAtIndexPath, completion: { (error) in
                if let error = error {
                    NSLog("Error fetching subcategory details: \(error)")
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchBarIsEmpty() == false {
            return NetworkController.filteredObjects.count
        }
        return networkController?.subcategoryDetails.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ServiceResultTableViewCell.reuseIdentifier, for: indexPath) as! ServiceResultTableViewCell
        
        // Display the search results
        if searchBarIsEmpty() == false {
            let filteredSubcategoryDetail = NetworkController.filteredObjects[indexPath.row]
            cell.serviceNameLabel.text = filteredSubcategoryDetail.name
            cell.serviceAddressLabel.text = filteredSubcategoryDetail.address
            
            if let phoneJSON = filteredSubcategoryDetail.phone {
                cell.servicePhoneLabel.text = phoneJSON as? String
            }
            
            if filteredSubcategoryDetail.phone == nil || filteredSubcategoryDetail.phone as? String == "" {
                cell.servicePhoneLabel.isHidden = true
                cell.servicePhoneIcon.isHidden = true
            }
            
            cell.serviceHoursLabel.text = filteredSubcategoryDetail.hours
            
            if filteredSubcategoryDetail.hours == nil {
                cell.serviceHoursLabel.isHidden = true
                cell.serviceHoursIcon.isHidden = true
            }
        } else {
            // Display the subcategory resources
            let subcategoryDetail = networkController?.subcategoryDetails[indexPath.row]
            cell.serviceNameLabel.text = subcategoryDetail?.name
            cell.serviceAddressLabel.text = subcategoryDetail?.address
            
            if let phoneJSON = subcategoryDetail?.phone {
                cell.servicePhoneLabel.text = phoneJSON as? String
            }
            
            if subcategoryDetail?.phone == nil || subcategoryDetail?.phone as? String == ""{
                cell.servicePhoneLabel.isHidden = true
                cell.servicePhoneIcon.isHidden = true
            }
            
            // Either hide labels or write "Unavailable"
            cell.serviceHoursLabel.text = subcategoryDetail?.hours
            
            if subcategoryDetail?.hours == nil {
                cell.serviceHoursLabel.isHidden = true
                cell.serviceHoursIcon.isHidden = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    // MARK: - Search Bar
    
    // Tell the delegate that the search button was tapped
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        filterServiceResults()
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
    
    func filterServiceResults() {
        
        DispatchQueue.main.async {
            
            guard let searchTerm = self.searchBar.text, !searchTerm.isEmpty else {
                // If no search term, display all of the search results
                NetworkController.filteredObjects = (self.networkController?.subcategoryDetails)!
                return
            }
            
            // Filter through array to see if keywords contain the text entered by user
            var matchingObjects = NetworkController.filteredObjects.filter({ $0.keywords.contains(searchTerm.lowercased()) })
            
            // Set the value of filteredObjects to the results of the filter
            NetworkController.filteredObjects = matchingObjects
            
            self.tableView.reloadData()
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchBar.text?.isEmpty ?? true
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        guard let destination = segue.destination as? ServiceDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
        
        // Pass the search results array
        if searchBarIsEmpty() == false {
            let serviceDetail = NetworkController.filteredObjects[indexPath.row]
            destination.serviceDetail = serviceDetail
            destination.networkController = networkController
        } else {
            // Pass the subcategory results array
            destination.networkController = networkController
            
            if networkController?.subcategoryDetails == nil {
                return
            } else {
                let serviceDetail = networkController?.subcategoryDetails[indexPath.row]
                destination.serviceDetail = serviceDetail
            }
        }
        

        
//        if networkController?.shelterSubcategoryDetails == nil {
//            return
//        } else {
//            let shelterServiceDetail = networkController?.shelterSubcategoryDetails[indexPath.row]
//            destination.shelterServiceDetail = shelterServiceDetail
//        }
            
    }
    

    

}
