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

class CategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var helpView: UIView!
    
    @IBOutlet weak var categoriesScrollView: UIScrollView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewSearchBar: UISearchBar!
    
    @IBOutlet weak var nearestShelterView: UIView!
    @IBOutlet weak var nearestShelterLabel: UILabel!
    @IBOutlet weak var shelterView: UIView!
    @IBOutlet weak var shelterNameLabel: UILabel!
    
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var shelterAddressLabel: UILabel!
    
    
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var shelterDistanceLabel: UILabel!
    @IBOutlet weak var shelterDurationLabel: UILabel!
    
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var shelterPhoneLabel: UILabel!
    @IBOutlet weak var shelterHoursLabel: UILabel!
    @IBOutlet weak var viewMapButton: UIButton!
    @IBOutlet weak var viewDetailsButton: UIButton!
    
    @IBOutlet weak var addressImageView: UIImageView!
    @IBOutlet weak var transitImageView: UIImageView!
    @IBOutlet weak var walkImageView: UIImageView!
    @IBOutlet weak var phoneImageView: UIImageView!
    @IBOutlet weak var hoursImageView: UIImageView!
    
    @IBOutlet weak var bottomBarView: UIView!
    
    let categoryController = CategoryController()
    var networkController: NetworkController?
    let cacheController = CacheController()
    
    var serviceCoordinates: CLLocationCoordinate2D?

    var serviceDistance: String!
    var serviceTravelDuration: String!
    
    var nearestShelter: IndividualResource?
    var nearestDistance: [Element]?
    var destinationAddresses: [String]?
    
    let locationManager = CLLocationManager()
    
    let googleMapsController = GoogleMapsController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
        
        networkController?.subcategoryNames = []
        
        // Set Delegate & DataSource
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        collectionViewSearchBar.delegate = self
        
        navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.barTintColor = nil
        
        setupTheme()
        
        updateNearestShelter()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionViewSearchBar.text = ""
        
        networkController?.subcategoryNames = []
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        networkController?.fetchCategoryNames { (error) in
            
            if let error = error {
                NSLog("Error fetching categories: \(error)")
            }
            DispatchQueue.main.async {
                self.categoriesCollectionView.reloadData()
            }
        }
    }
    
    @IBAction func spanishButtonClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "La traducción al español vendrá pronto.", message: "Spanish translation coming soon.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    
    @IBAction func viewMapClicked(_ sender: Any) {
        
        guard let unwrappedServiceCoordinate = serviceCoordinates else { return }
        
        print("Launch Google Maps URL: https://www.google.com/maps/dir/?api=1&origin=\(unwrappedServiceCoordinate.latitude),\(unwrappedServiceCoordinate.longitude)&destination=\(String(describing: nearestShelter?.latitude!)),\(String(describing: nearestShelter?.longitude!))&travelmode=transit")
        
        if let url = URL(string: "https://www.google.com/maps/dir/?api=1&origin=\(unwrappedServiceCoordinate.latitude),\(unwrappedServiceCoordinate.longitude)&destination=\(nearestShelter!.latitude!),\(nearestShelter!.longitude!)&travelmode=transit") {
            
            UIApplication.shared.open(url, options: [:])
        }
    }
    @IBAction func viewDetailsClicked(_ sender: Any) {
        performSegue(withIdentifier: "shelterNearestYouSegue", sender: nil)
    }
    
    @IBAction func unwindToSubcategoriesVC(segue:UIStoryboardSegue) {
        //performSegue(withIdentifier: "unwindToSubcategoriesVC", sender: self)
    }
    
    // MARK - Collection View Data Source Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return networkController?.categoryNames.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoriesCollectionViewCell
        
        guard let category = networkController?.categoryNames[indexPath.row] else { return cell}
        
        cell.categoryNameLabel.adjustsFontSizeToFitWidth = true
        
        if category == "Outreach Services" {
            cell.categoryNameLabel.text = " OUTREACH "
        } else if category == "Legal Administrative" {
             cell.categoryNameLabel.text = "LEGAL"
        } else if category == "Health Care" {
            cell.categoryNameLabel.text = " HEALTHCARE "
        } else if category == "Education" {
            cell.categoryNameLabel.text = " EDUCATION "
        } else {
            cell.categoryNameLabel.text = category.uppercased()
        }
        
        categoryController.getIconImage(from: category)
        cell.categoryImageView.image = categoryController.iconImage
        
        cell.cellView.backgroundColor = UIColor.customDarkGray
        cell.cellView.layer.cornerRadius = 10
        cell.cellView.layer.borderColor = UIColor.white.cgColor
        cell.cellView.layer.borderWidth = 2
        
        cell.cellView.setViewShadow(color: UIColor.black, opacity: 0.5, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
        
        cell.categoryNameLabel.textColor = UIColor.white
        
//        cell.contentView.setViewShadow(color: UIColor.black, opacity: 0.5, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
//        cell.contentView.layer.cornerRadius = 10
//        cell.contentView.layer.borderColor = UIColor.customLightestGray.cgColor
//        cell.contentView.layer.borderWidth = 2
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let categoryAtIndexPath = networkController?.categoryNames[indexPath.row] else { return }
        
        networkController?.tempCategorySelection = categoryAtIndexPath

        performSegue(withIdentifier: "modalSubcategoryMenu", sender: nil)
    }
    
    // MARK: - UI Search Bar

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        filterServiceResults()
        
        performSegue(withIdentifier: "searchResultsSegue", sender: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func filterServiceResults() {
        // Grab the text, make sure it's not empty

        guard let searchTerm = self.collectionViewSearchBar.text, !searchTerm.isEmpty else {
            return
        }
        
        let matchingObjects = NetworkController.filteredObjects.filter({ $0.keywords.contains(searchTerm.lowercased()) || $0.name.contains(searchTerm.lowercased()) })

        networkController?.subcategoryDetails = matchingObjects
    }

    // MARK: - Shelter Nearest User Location
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            serviceCoordinates = manager.location?.coordinate
            print("serviceCoordinates: \(String(describing: serviceCoordinates))")
            locationManager.stopUpdatingLocation()
        } else {
            print("User location is unavailable")
        }
        getNearestShelter()
        updateNearestShelter()
    }
    
    // MARK: - Shelter Nearest You Method
    private func getNearestShelter() {
        
        guard let unwrappedServiceCoordinate = serviceCoordinates else { return }
        
        googleMapsController.fetchNearestShelter(unwrappedServiceCoordinate.latitude, unwrappedServiceCoordinate.longitude) { (error) in
            if let error = error {
                print("Error fetching distance to chosen service: \(error)")
            }

            self.serviceDistance = self.googleMapsController.serviceDistance
            self.serviceTravelDuration = self.googleMapsController.serviceTravelDuration
            
            print("serviceDistance: \(String(describing: self.serviceDistance))")
            print("serviceTravelDuration: \(String(describing: self.serviceTravelDuration))")
            
            DispatchQueue.main.async {
                self.updateNearestShelter()
            }
            
            self.destinationAddresses = self.googleMapsController.serviceAddresses
            self.nearestDistance = self.googleMapsController.googleDistanceResponse[0].elements
            
            guard var unwrappedShelters = self.nearestDistance else { return }
            
            var shelter = unwrappedShelters[0] //.distance.value
            var index = 0
            var shelterIndex = 0
            var shelterTuple = (shelterIndex, shelter)
            
            for each in unwrappedShelters {
 
                if each.distance.value < shelter.distance.value {
                    shelter = each
                    shelterIndex = index
                    shelterTuple = (shelterIndex, shelter)
                }
                index += 1
            }
            
            let fetchedShelter = self.googleMapsController.serviceAddresses[ shelterIndex ]
            var splitAddress = fetchedShelter.split(separator: " ")
            let addressNumber = splitAddress[0]
            
            for eachShelter in NetworkController.allShelterObjects {
                
                if (eachShelter.address?.contains(addressNumber))! {
                    self.nearestShelter = eachShelter
                }
            }
        }
    }
    
    private func updateNearestShelter() {
        
        shelterNameLabel.text = nearestShelter?.name
        
        if nearestShelter?.address == nil || nearestShelter?.address == "" {
            shelterAddressLabel.text = "Address unavailable"
        } else {
            shelterAddressLabel.text = nearestShelter?.address
        }
        
        if nearestShelter?.hours == nil || nearestShelter?.hours == "" {
            shelterHoursLabel.text = "Please call for hours"
        } else {
            shelterHoursLabel.text = nearestShelter?.hours
            shelterHoursLabel.adjustsFontSizeToFitWidth = true
        }
        
        if let phoneJSON = nearestShelter?.phone {
            shelterPhoneLabel.text = phoneJSON as? String
        } else if nearestShelter?.phone == nil {
            shelterPhoneLabel.text = "Phone number unavailable"
        }
        
        if serviceDistance == nil || serviceDistance == "" {
            shelterDistanceLabel.text = "Unavailable"
        } else {
            guard let unwrappedDistance = serviceDistance else { return }
            shelterDistanceLabel.text = unwrappedDistance
        }
        
        if serviceTravelDuration == nil || serviceTravelDuration == "" {
            shelterDurationLabel.text = "Unavailable"
        } else {
            guard let unwrappedDuration = serviceTravelDuration else { return }
            shelterDurationLabel.text = unwrappedDuration
        }
        
        // Adjust fonts
        shelterNameLabel.adjustsFontSizeToFitWidth = true
        shelterAddressLabel.adjustsFontSizeToFitWidth = true
        shelterHoursLabel.adjustsFontSizeToFitWidth = true
        shelterPhoneLabel.adjustsFontSizeToFitWidth = true
        shelterDistanceLabel.adjustsFontSizeToFitWidth = true
        shelterDurationLabel.adjustsFontSizeToFitWidth = true
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "searchResultsSegue" {
            let searchDestinationVC = segue.destination as! ServiceResultsViewController
            searchDestinationVC.networkController = networkController
            
        }
        
        if let destinationViewController = segue.destination as? SubcategoriesViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
            destinationViewController.menuActionDelegate = self
        }
        
        if segue.identifier == "modalSubcategoryMenu" {
            let destination = segue.destination as! SubcategoriesViewController
            destination.networkController = networkController
            destination.googleMapsController = googleMapsController
            destination.selectedCategory = networkController?.tempCategorySelection
        }
        
        if segue.identifier == "shelterNearestYouSegue" {
            let destination = segue.destination as! ServiceDetailViewController
            destination.networkController = networkController
            destination.serviceDetail = nearestShelter
            destination.serviceDistance = self.serviceDistance
            destination.serviceTravelDuration = self.serviceTravelDuration
        }
    }
    
    // MARK: - Theme
    
    func setupTheme() {
        
        // Set navigation bar to the default color
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        helpView.backgroundColor = UIColor.customDarkPurple
        helpView.layer.cornerRadius = 5
        helpLabel.textColor = UIColor.white
        
        viewDetailsButton.setTitle("  VIEW DETAILS", for: .normal)
        viewDetailsButton.setTitleColor(.white, for: .normal)
        //viewDetailsButton.titleLabel?.font = Appearance.boldFont
        viewDetailsButton.backgroundColor = .customDarkPurple
        viewDetailsButton.layer.cornerRadius = 5
        viewDetailsButton.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
        
        let launchColoredIcon = UIImage(named: "launch")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        viewDetailsButton.tintColor = .white
        viewDetailsButton.setImage(launchColoredIcon, for: .normal)
        
        viewMapButton.setTitle("  View Map", for: .normal)
        viewMapButton.setTitleColor(UIColor.customDarkPurple, for: .normal)
        viewMapButton.backgroundColor = .white
        viewMapButton.layer.borderWidth = 0.25
        viewMapButton.layer.borderColor = UIColor.lightGray.cgColor
        
        let nearMeColoredIcon = UIImage(named: "near_me")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        viewMapButton.tintColor = .customDarkPurple
        viewMapButton.setImage(nearMeColoredIcon, for: .normal)
        
        shelterNameLabel.textColor = .customDarkBlack
        shelterNameLabel.font = Appearance.regularFont
        shelterDistanceLabel.layer.addBorder(edge: .left, color: .lightGray, thickness: 0.25)
        
        nearestShelterLabel.textColor = .customDarkPurple
        nearestShelterLabel.font = Appearance.boldFont
        nearestShelterView.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
        
        helpView.backgroundColor = UIColor.customDarkPurple
        helpView.layer.cornerRadius = 5
        helpLabel.textColor = UIColor.white
        helpView.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
        
        // Icon Colors
        let placeColoredIcon = UIImage(named: "place")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        addressImageView.tintColor = .customDarkPurple
        addressImageView.image = placeColoredIcon
        
        let busColoredIcon = UIImage(named: "bus")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        transitImageView.tintColor = .customDarkPurple
        transitImageView.image = busColoredIcon
        
        let walkColoredIcon = UIImage(named: "walk")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        walkImageView.tintColor = .customDarkPurple
        walkImageView.image = walkColoredIcon
        
        let phoneColoredIcon = UIImage(named: "phone")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        phoneImageView.tintColor = .customDarkPurple
        phoneImageView.image = phoneColoredIcon
        
        let clockColoredIcon = UIImage(named: "clock")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        hoursImageView.tintColor = .customDarkPurple
        hoursImageView.image = clockColoredIcon
        
        shelterView.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
        
        addressView.layer.borderWidth = 0.25
        addressView.layer.borderColor = UIColor.lightGray.cgColor
        distanceView.layer.borderWidth = 0.25
        distanceView.layer.borderColor = UIColor.lightGray.cgColor
        contactView.layer.borderWidth = 0.25
        contactView.layer.borderColor = UIColor.lightGray.cgColor
        
        bottomBarView.backgroundColor = .customLightPurple
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
        performSegue(withIdentifier: "modalSubcategoryMenu", sender: nil)
        
    }
}




