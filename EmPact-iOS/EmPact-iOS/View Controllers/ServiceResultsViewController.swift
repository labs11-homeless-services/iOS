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
        performSegue(withIdentifier: "unwindToSubcategoriesVC", sender: self)
        
    }
    
    var selectedSubcategory: String!
    
    var networkController: NetworkController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        searchBar.delegate = self
        
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.barTintColor = UIColor.white
        searchBar.placeholder = "Search"
        
        if networkController?.tempCategorySelection == "" {
            self.title = ""
        } else {
            guard let unwrappedTempCategorySelection = networkController?.tempCategorySelection else { return }
            self.title = "\(unwrappedTempCategorySelection) - \(selectedSubcategory.capitalized)"
        }
        
        
//        
//        if unwrappedTempCategorySelection == "" {
//            self.title = ""
//        } else {
//            
//        }

        
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
        return networkController?.subcategoryDetails.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ServiceResultTableViewCell.reuseIdentifier, for: indexPath) as! ServiceResultTableViewCell
        
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        guard let destination = segue.destination as? ServiceDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
        
        // Pass the selected object to the new view controller.
        destination.networkController = networkController
        
        if networkController?.subcategoryDetails == nil {
            return
        } else {
            let serviceDetail = networkController?.subcategoryDetails[indexPath.row]
            destination.serviceDetail = serviceDetail
        }
        
//        if networkController?.shelterSubcategoryDetails == nil {
//            return
//        } else {
//            let shelterServiceDetail = networkController?.shelterSubcategoryDetails[indexPath.row]
//            destination.shelterServiceDetail = shelterServiceDetail
//        }
            
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchBar.text?.isEmpty ?? true
    }
    

}
