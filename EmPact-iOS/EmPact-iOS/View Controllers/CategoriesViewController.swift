//
//  CategoriesViewController.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 3/29/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit
import CoreLocation

// MARK: - Hamburger Menu protocol
protocol MenuActionDelegate {
    func openSegue(_ segueName: String, sender: AnyObject?)
    func reopenMenu()
}

class CategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var helpView: UIView!
    
    @IBOutlet weak var categoriesScrollView: UIScrollView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewSearchBar: UISearchBar!
    
    @IBOutlet weak var shelterView: UIView!
    @IBOutlet weak var shelterNameLabel: UILabel!
    @IBOutlet weak var shelterAddressLabel: UILabel!
    @IBOutlet weak var shelterDistanceLabel: UILabel!
    @IBOutlet weak var shelterDurationLabel: UILabel!
    @IBOutlet weak var shelterPhoneLabel: UILabel!
    @IBOutlet weak var shelterHoursLabel: UILabel!
    @IBOutlet weak var viewMapButton: UIButton!
    @IBOutlet weak var viewDetailsButton: UIButton!
    
    @IBAction func viewMapClicked(_ sender: Any) {
    }
    @IBAction func viewDetailsClicked(_ sender: Any) {
    }
    
    
    @IBAction func unwindToSubcategoriesVC(segue:UIStoryboardSegue) {
        //dismiss(animated: true, completion: nil)
    }
    
    let categoryController = CategoryController()
    let networkController = NetworkController()
    let cacheController = CacheController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Delegate & DataSource
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        collectionViewSearchBar.delegate = self
        
        collectionViewSearchBar.searchBarStyle = UISearchBar.Style.minimal
        collectionViewSearchBar.barTintColor = UIColor.white
        collectionViewSearchBar.placeholder = "Search"
        
        helpView.backgroundColor = UIColor.darkGray
        helpView.layer.cornerRadius = 5
        helpLabel.textColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        networkController.fetchCategoryNames { (error) in

            if let error = error {
                NSLog("Error fetching categories: \(error)")
            }
            DispatchQueue.main.async {
                self.categoriesCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return networkController.categoryNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoriesCollectionViewCell
        
        let category = networkController.categoryNames[indexPath.row]
        cell.categoryNameLabel.text = category
        
        categoryController.getIconImage(from: category)
        cell.categoryImageView.image = categoryController.iconImage
        
        cell.cellView.backgroundColor = UIColor.darkGray
        cell.cellView.layer.cornerRadius = 10
        //cell.cellView.layer.borderColor = UIColor.white.cgColor
        //cell.cellView.layer.borderWidth = 2
        
        cell.cellView.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
        
        cell.categoryNameLabel.textColor = UIColor.white
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let categoryAtIndexPath = networkController.categoryNames[indexPath.row]
        networkController.tempCategorySelection = categoryAtIndexPath

        performSegue(withIdentifier: "modalSubcategoryMenu", sender: nil)
    }
    
    // MARK: = UI Search Bar
    
    // Tell the delegate the search button was tapped
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        // Filter the results based on the text in the search bar
        filterServiceResults()
        
        // Perform segue to Service Results View Controller
        performSegue(withIdentifier: "searchResultsSegue", sender: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func filterServiceResults() {
        
        // Grab the text, make sure it's not empty
        guard let searchTerm = self.collectionViewSearchBar.text, !searchTerm.isEmpty else {
            
            // If no search term...
            //NetworkController.filteredObjects = self.networkController.subcategoryDetails
            
            return
        }
        
        var matchingObjects = NetworkController.filteredObjects.filter({ $0.keywords.contains(searchTerm.lowercased()) })
        
        //print("Matching Objects array which is the filtered results by search term: \(matchingObjects)")
        
        networkController.subcategoryDetails = matchingObjects
        
        //print("Subcategory Details array from filterServiceResults function that should be the same as Matching Objects: \(networkController.subcategoryDetails)")

        // Add matching objects to the filtered objects array
//        for eachObject in matchingShelterObjects {
//
//            // Do we need a filteredObjects array?
//            NetworkController.filteredObjects.append(eachObject)
//
//        }
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "searchResultsSegue" {
            let searchDestinationVC = segue.destination as! ServiceResultsViewController
            searchDestinationVC.networkController = networkController
            //searchDestinationVC.selectedSubcategory = 
        }
        
        if let destinationViewController = segue.destination as? SubcategoriesViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
            destinationViewController.menuActionDelegate = self
        }
        
        if segue.identifier == "modalSubcategoryMenu" {
            let destination = segue.destination as! SubcategoriesViewController
            destination.networkController = networkController
            destination.selectedCategory = networkController.tempCategorySelection
        }
    }
    
    // MARK: - Hamburger Menu Variables
    let interactor = Interactor()
    var seguePerformed = false
}

// MARK: - Hamburger Menu Extensions
extension CategoriesViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

extension CategoriesViewController : MenuActionDelegate {
    func openSegue(_ segueName: String, sender: AnyObject?) {
        dismiss(animated: true){
            self.performSegue(withIdentifier: segueName, sender: sender)
        }
    }
    
    func reopenMenu(){
        performSegue(withIdentifier: "showResultsTableVC", sender: nil)
        
    }
}

//showResultsTableVC

//networkController.fetchSubcategoriesNames(SubCategory.shelters)       // Shelters: WORKS!!!!
//networkController.fetchSubcategoriesNames(SubCategory.education)      // Phone: Expected to decode Int but found a string/data
//networkController.fetchSubcategoriesNames(SubCategory.legal)          // Phone: Expected to decode Int but found a string/data
//networkController.fetchSubcategoriesNames(SubCategory.food)           // Phone: Expected to decode Int but found a string/data
//networkController.fetchSubcategoriesNames(SubCategory.healthcare)     // Details: Expected to decode String but found a dictionary instead
//networkController.fetchSubcategoriesNames(SubCategory.outreach)       // Convert from Kebab case
//networkController.fetchSubcategoriesNames(SubCategory.hygiene)        // Phone: Expected to decode Int but found a string/data
//networkController.fetchSubcategoriesNames(SubCategory.jobs)           // Phone: Expected to decode Int but found a string/data
