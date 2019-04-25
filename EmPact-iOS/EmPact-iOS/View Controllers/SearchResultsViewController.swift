//
//  SearchResultsViewController.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/23/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchedView: UIView!
    @IBOutlet weak var searchedTitleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var googleMapsController: GoogleMapsController?
    var networkController: NetworkController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegates
        self.tableView.delegate = self
        self.tableView.dataSource = self
        searchBar.delegate = self
        
        self.hideKeyboard()
        
        setupTheme()
        
        navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.barTintColor = nil
        
        // Set navigation bar to the default color
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)

        self.title = "Search Results"
        guard let unwrappedSearchTerm = networkController?.searchTerm else { return }
        searchedTitleLabel.text = "Search Results: \(unwrappedSearchTerm)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.text = ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkController?.subcategoryDetails.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsTableViewCell.reuseIdentifier, for: indexPath) as! SearchResultsTableViewCell
        
        let subcategoryDetail = networkController?.subcategoryDetails[indexPath.row]
        
        cell.searchResultNameLabel.textColor = UIColor.customLightBlack
        
        // Icons
        let placeColoredIcon = UIImage(named: "place")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        cell.addressIconImage.tintColor = .customDarkPurple
        cell.addressIconImage.image = placeColoredIcon
        
        let coloredPhoneIcon = UIImage(named: "phone")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        cell.phoneIconImage.tintColor = .customDarkPurple
        cell.phoneIconImage.image = coloredPhoneIcon
        
        let coloredClockIcon = UIImage(named: "clock")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        cell.hoursIconImage.tintColor = .customDarkPurple
        cell.hoursIconImage.image = coloredClockIcon
        
        // Button
        cell.viewButton.setTitle("  VIEW", for: .normal)
        cell.viewButton.setTitleColor(.white, for: .normal)
        cell.viewButton.backgroundColor = .customDarkPurple
        
        let launchColoredIcon = UIImage(named: "launch")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        cell.viewButton.tintColor = UIColor.white
        cell.viewButton.setImage(launchColoredIcon, for: .normal)
        cell.viewButton.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
        
        cell.viewButton.layer.cornerRadius = 5
        cell.searchResultsView.layer.borderColor = UIColor.lightGray.cgColor
        cell.searchResultsView.layer.borderWidth = 0.5
        
        // Name
        cell.searchResultNameLabel.text = subcategoryDetail?.name
        
        // Address
        cell.addressLabel.text = subcategoryDetail?.address
        if subcategoryDetail?.address == nil || subcategoryDetail?.address == "" {
            cell.addressLabel.text = "Address unavailable"
        }
        
        // Phone
        if let phoneJSON = subcategoryDetail?.phone {
            cell.phoneLabel.text = phoneJSON as? String
        }
        if subcategoryDetail?.phone == nil || subcategoryDetail?.phone as? String == "" {
            cell.phoneLabel.text = "Phone number unavailable"
        }
        
        // Hours
        cell.hoursLabel.text = subcategoryDetail?.hours
        if subcategoryDetail?.hours == nil || subcategoryDetail?.hours == "" {
            cell.hoursLabel.text = "Please call for hours"
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        // Adjust fonts
        cell.searchResultNameLabel.adjustsFontSizeToFitWidth = true
        cell.addressLabel.adjustsFontSizeToFitWidth = true
        cell.phoneLabel.adjustsFontSizeToFitWidth = true
        cell.hoursLabel.adjustsFontSizeToFitWidth = true
        
        return cell
    }
    
    // MARK: - UI Search Bar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        networkController?.subcategoryDetails = []
        
        filterServiceResults()
        
        DispatchQueue.main.async {
            guard let unwrappedSearchTerm = self.networkController?.searchTerm else { return }
            self.searchedTitleLabel.text = "Search Results: \(unwrappedSearchTerm)"
            
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
    
    func filterServiceResults() {
        guard let searchTerm = self.searchBar.text, !searchTerm.isEmpty else { return }
        
        networkController?.searchTerm = searchTerm
        
        let matchingObjects = NetworkController.filteredObjects.filter({ $0.keywords.contains(searchTerm.lowercased()) || $0.name.contains(searchTerm.lowercased()) })
        
        networkController?.subcategoryDetails = matchingObjects
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "searchResultsDetails" {
            
            guard let destination = segue.destination as? ServiceDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            
            destination.googleMapsController = googleMapsController
            destination.networkController = networkController
            
            let serviceDetail = networkController?.subcategoryDetails[indexPath.row]
            destination.serviceDetail = serviceDetail
        }
    }

    func setupTheme() {
        searchedTitleLabel.textColor = UIColor.white
        searchedTitleLabel.backgroundColor = UIColor.customDarkPurple
        searchedView.backgroundColor = .customDarkPurple
        searchedView.layer.cornerRadius = 5
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        searchedView.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
    }
    
}
