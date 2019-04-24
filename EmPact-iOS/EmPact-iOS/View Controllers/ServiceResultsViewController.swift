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
    
    @IBAction func unwindToSubcategoriesVC(segue:UIStoryboardSegue) {
        networkController?.subcategoryNames = []
        networkController?.subcategoryDetails = []
        networkController?.tempCategorySelection = ""
        selectedSubcategory = ""
        
        // If statement accounts for if hamburger menu was skipped over
        if segue.identifier == "unwindToSubcategoriesVC" {
            networkController?.subcategoryDetails = []
            performSegue(withIdentifier: "unwindToSubcategoriesVC", sender: self)
        }
        
        if segue.identifier == "landingToServiceResultsSegue" {
            networkController?.subcategoryDetails = []
            performSegue(withIdentifier: "landingToServiceResultsSegue", sender: self)
        }
    }
    
    var selectedSubcategory: String!
    
    var googleMapsController: GoogleMapsController?
    var networkController: NetworkController?
    
    var matchingObjects: [IndividualResource]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
        
        //networkController?.subcategoryDetails = []
        
        navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.barTintColor = nil
        
        // Set navigation bar to the default color
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
        
        setupTheme()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        searchBar.delegate = self
        
        if networkController?.tempCategorySelection == "" || networkController?.tempCategorySelection == nil {
            self.title = "Search Results"
            guard let unwrappedSearchTerm = networkController?.searchTerm else { return }
            subcategoriesTitleLabel.text = "Search Results: \(unwrappedSearchTerm)"
        } else if selectedSubcategory == "" || selectedSubcategory == nil {
            guard let unwrappedSearchTerm = networkController?.searchTerm else { return }
            self.title = "Search Results"
            subcategoriesTitleLabel.text = "Search Results: \(unwrappedSearchTerm)"
        } else {
            guard let unwrappedTempCategorySelection = networkController?.tempCategorySelection else { return }
            self.title = "\(unwrappedTempCategorySelection) - \(selectedSubcategory.capitalized)"
            subcategoriesTitleLabel.text = "\(selectedSubcategory.uppercased()) | \(unwrappedTempCategorySelection.uppercased()) within New York City, NY"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.text = ""
        
        //networkController?.subcategoryDetails = []
        
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
            return matchingObjects?.count ?? 0
        } else {
            return networkController?.subcategoryDetails.count ?? 0
        }
        
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
        cell.viewDetailsButton.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
        
        cell.viewDetailsButton.layer.cornerRadius = 5
        cell.resultsView.layer.borderColor = UIColor.lightGray.cgColor
        cell.resultsView.layer.borderWidth = 0.5
        
        // Display the search results
        //if searchBarIsEmpty() == false {
        if matchingObjects != nil {
            guard let filteredSubcategoryDetail = matchingObjects?[indexPath.row] else { return cell }
            
            // Name
            cell.serviceNameLabel.text = filteredSubcategoryDetail.name
            
            // Address
            cell.serviceAddressLabel.text = filteredSubcategoryDetail.address
            if filteredSubcategoryDetail.address == nil || filteredSubcategoryDetail.address == "" {
                cell.serviceAddressLabel.text = "Address unavailable"
            }
            
            // Phone
            if let phoneJSON = filteredSubcategoryDetail.phone {
                cell.servicePhoneLabel.text = phoneJSON as? String
            }
            if filteredSubcategoryDetail.phone == nil || filteredSubcategoryDetail.phone as? String == "" {
                cell.servicePhoneLabel.text = "Phone number unavailable"
            }
            
            // Hours
            cell.serviceHoursLabel.text = filteredSubcategoryDetail.hours
            if filteredSubcategoryDetail.hours == nil || filteredSubcategoryDetail.hours == "" {
                cell.serviceHoursLabel.text = "Please call for hours"
            }
            
        // Display the subcategory resources
        } else {
            
            let subcategoryDetail = networkController?.subcategoryDetails[indexPath.row]
            
            // Name
            cell.serviceNameLabel.text = subcategoryDetail?.name
            
            // Address
            cell.serviceAddressLabel.text = subcategoryDetail?.address
            if subcategoryDetail?.address == nil || subcategoryDetail?.address == "" {
                cell.serviceAddressLabel.text = "Address unavailable"
            }
            
            // Phone
            if let phoneJSON = subcategoryDetail?.phone {
                cell.servicePhoneLabel.text = phoneJSON as? String
            }
            if subcategoryDetail?.phone == nil || subcategoryDetail?.phone as? String == ""{
                cell.servicePhoneLabel.text = "Phone number unavailable"
            }
            
            // Hours
            cell.serviceHoursLabel.text = subcategoryDetail?.hours
            
            if subcategoryDetail?.hours == nil || subcategoryDetail?.hours == "" {
                cell.serviceHoursLabel.text = "Please call for hours"
            }
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    @IBAction func spanishButtonClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "La traducción al español vendrá pronto.", message: "Spanish translation coming soon.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    // MARK: - Search Bar
    // Tell the delegate that the search button was tapped
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        networkController?.subcategoryDetails = []
        matchingObjects = []
        
        filterServiceResults()
        
        DispatchQueue.main.async {
            self.title = "Search Results"
            guard let unwrappedSearchTerm = self.networkController?.searchTerm else { return }
            self.subcategoriesTitleLabel.text = "Search Results: \(unwrappedSearchTerm)"
            
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //networkController?.subcategoryDetails = []
        tableView.reloadData()
    }
    
    func filterServiceResults() {
        
        DispatchQueue.main.async {
            guard let searchTerm = self.searchBar.text, !searchTerm.isEmpty else {
                // If no search term, display all of the search results
                //matchingObjects = self.networkController?.subcategoryDetails
                //NetworkController.filteredObjects = (self.networkController?.subcategoryDetails)!
                return
            }
            
            self.networkController?.searchTerm = searchTerm
            
            // Filter through array to see if keywords contain the text entered by user
            let matchingObjects = NetworkController.filteredObjects.filter({ $0.keywords.contains(searchTerm.lowercased()) || $0.name.contains(searchTerm.lowercased()) })
            
            // Set the value of matchingObjects to the results of the filter
            self.matchingObjects = matchingObjects

            self.tableView.reloadData()
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchBar.text?.isEmpty ?? true
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "backToCategories" {
            networkController?.subcategoryDetails = []
            let destination = segue.destination as! CategoriesViewController
            //performSegue(withIdentifier: "backToCategories", sender: self)
        }
        
        // Get the new view controller using segue.destination.
        guard let destination = segue.destination as? ServiceDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
        
        // Pass the search results array
        //if searchBarIsEmpty() == false {
        if matchingObjects != nil {
            //let serviceDetail = NetworkController.filteredObjects[indexPath.row]
            let serviceDetail = matchingObjects?[indexPath.row]
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
        subcategoriesTitleView.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
    }
    
}





