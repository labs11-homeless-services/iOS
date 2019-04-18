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
    @IBOutlet weak var subcategoriesTitleView: UIView!
    @IBOutlet weak var viewDetailsButton: UIButton!
    
    @IBAction func unwindToSubcategoriesVC(segue:UIStoryboardSegue) {
        networkController?.subcategoryNames = []
        networkController?.subcategoryDetails = []
        networkController?.tempCategorySelection = ""
        selectedSubcategory = ""
        performSegue(withIdentifier: "unwindToSubcategoriesVC", sender: self)
    }
    
    var selectedSubcategory: String!
    
    var googleMapsController: GoogleMapsController?
    var networkController: NetworkController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTheme()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        searchBar.delegate = self
        
        if networkController?.tempCategorySelection == "" {
            self.title = "Search Results"
        } else {
            guard let unwrappedTempCategorySelection = networkController?.tempCategorySelection else { return }
            self.title = "\(unwrappedTempCategorySelection) - \(selectedSubcategory.capitalized)"
            subcategoriesTitleLabel.text = "\(selectedSubcategory.uppercased()) \(unwrappedTempCategorySelection.uppercased()) within New York City, NY"
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
        
        cell.serviceNameLabel.textColor = UIColor.customLightBlack
        
        // Icons
        let placeColoredIcon = UIImage(named: "place")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        cell.serviceAddressIcon.tintColor = .customDarkPurple
        cell.serviceAddressIcon.image = placeColoredIcon

        let coloredPhoneIcon = UIImage(named: "phone")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        cell.servicePhoneIcon.tintColor = .customDarkPurple
        cell.servicePhoneIcon.image = coloredPhoneIcon
        
        let coloredClockIcon = UIImage(named: "clock")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        cell.serviceHoursIcon.tintColor = .customDarkPurple
        cell.serviceHoursIcon.image = coloredClockIcon
        
        // Button
        cell.viewDetailsButton.setTitle("  VIEW", for: .normal)
        cell.viewDetailsButton.setTitleColor(.white, for: .normal)
        cell.viewDetailsButton.backgroundColor = .customDarkPurple
        
        let launchColoredIcon = UIImage(named: "launch")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        cell.viewDetailsButton.tintColor = UIColor.white
        cell.viewDetailsButton.setImage(launchColoredIcon, for: .normal)
        
        cell.viewDetailsButton.layer.cornerRadius = 5
        
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
            destination.googleMapsController = googleMapsController
            destination.networkController = networkController
        } else {
            // Pass the subcategory results array
            destination.googleMapsController = googleMapsController
            destination.networkController = networkController
            
            if networkController?.subcategoryDetails == nil {
                return
            } else {
                let serviceDetail = networkController?.subcategoryDetails[indexPath.row]
                destination.serviceDetail = serviceDetail
            }
        }
    }
    
    // MARK: - Theme
    
    func setupTheme() {
        
        subcategoriesTitleLabel.textColor = UIColor.white
        subcategoriesTitleView.backgroundColor = UIColor.customDarkPurple
        subcategoriesTitleLabel.backgroundColor = .customDarkPurple
        subcategoriesTitleView.layer.cornerRadius = 5
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }

}
