//
//  ServiceDetailViewController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/29/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit
import GoogleMaps

class ServiceDetailViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    
    // Outlet for MapView
    @IBOutlet weak var mapView: GMSMapView!

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentButtonView: UIView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var servicesButton: UIButton!
    @IBOutlet weak var detailsButton: UIButton!
    
    // MARK: Info View Outlets
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoTravelView: UIView!
    @IBOutlet weak var infoAddressView: UIView!
    @IBOutlet weak var infoPhoneView: UIView!
    @IBOutlet weak var infoHoursView: UIView!
    
    @IBOutlet weak var serviceDetailNameLabel: UILabel!
    @IBOutlet weak var serviceDetailAddressLabel: UILabel!
    @IBOutlet weak var serviceDetailDistanceLabel: UILabel!
    @IBOutlet weak var serviceDetailWalkTimeLabel: UILabel!
    @IBOutlet weak var serviceDetailPhoneLabel: UILabel!
    @IBOutlet weak var serviceDetailHoursLabel: UILabel!
    
    @IBOutlet weak var addressIconImageView: UIImageView!
    @IBOutlet weak var transitIconImageView: UIImageView!
    @IBOutlet weak var walkIconImageView: UIImageView!
    @IBOutlet weak var phoneIconImageView: UIImageView!
    @IBOutlet weak var hoursIconImageView: UIImageView!
    
    
    // MARK: Service View Outlets
    @IBOutlet weak var serviceView: UIView!
    @IBOutlet weak var servicesInfoNameLabel: UILabel!
    @IBOutlet weak var serviesInfoTextView: UITextView!
    
    // MARK: Detail View Outlets
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var detailsNameLabel: UILabel!
    @IBOutlet weak var detailsTextView: UITextView!
    
    @IBOutlet weak var mapUnavailableView: UIView!
    @IBOutlet weak var mapUnavailableLabel: UILabel!
    @IBOutlet weak var startMapButton: UIButton!
    
    // MARK: - Properties
    
    var serviceDistance: String!
    var serviceTravelDuration: String!
    
    var serviceCoordinates: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    
    var googleMapsController: GoogleMapsController?
    var networkController: NetworkController?
    
    var serviceDetail: IndividualResource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
        
        mapView.delegate = self
        searchBar.delegate = self
        
        self.title = serviceDetail?.name
        
        setupTheme()
        
        detailsView.isHidden = true
        serviceView.isHidden = true
        infoView.isHidden = false
        mapUnavailableView.isHidden = true
        mapUnavailableView.alpha = 0.5
        mapUnavailableLabel.isHidden = true
        mapUnavailableView.backgroundColor = .customDarkPurple

        // Convert latitude/longitude strings to doubles
        if serviceDetail?.latitude == nil || serviceDetail?.longitude == nil {
            mapUnavailableView.isHidden = false
            mapUnavailableLabel.isHidden = false
            mapUnavailableLabel.textColor = .white
            
            startMapButton.isHidden = true
            serviceDetailDistanceLabel.text = "Unavailable"
            serviceDetailWalkTimeLabel.text = "Unavailable"
        
        } else {
            guard let doubleLatValue = NumberFormatter().number(from: (serviceDetail?.latitude)!)?.doubleValue,
                let doubleLongValue = NumberFormatter().number(from: (serviceDetail?.longitude)!)?.doubleValue
                else {
                    print("Latitude or Longitude is not a valid Double")
                    return
            }
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: doubleLatValue, longitude: doubleLongValue)
            marker.title = serviceDetail?.name
            marker.map = mapView
            
            mapView.camera = GMSCameraPosition(target: marker.position, zoom: 13, bearing: 0, viewingAngle: 0)
            
        }
        locationButton.layer.addBorder(edge: .bottom, color: .white, thickness: 3)
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.text = ""
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func updateViews() {
        
        serviceDetailNameLabel.text = serviceDetail?.name
        
        if serviceDetail?.address == nil {
            serviceDetailAddressLabel.text = "Address unavailable"
        } else {
            serviceDetailAddressLabel.text = serviceDetail?.address
        }
        
        if serviceDetail?.phone == nil {
            serviceDetailPhoneLabel.text = "Phone number unavailable"
        } else {
            if let phoneJSON = serviceDetail?.phone {
                serviceDetailPhoneLabel.text = phoneJSON as? String
            }
        }
        

        if serviceDetail?.hours == nil {
            serviceDetailHoursLabel.text = "Please call for hours"
        } else {
           serviceDetailHoursLabel.text = serviceDetail?.hours
        }
        
        guard let unwrappedDistance = serviceDistance,
            let unwrappedDuration = serviceTravelDuration else { return }
        
        serviceDetailDistanceLabel.text = unwrappedDistance
        serviceDetailWalkTimeLabel.text = unwrappedDuration
        
        if serviceDistance == nil {
            serviceDetailDistanceLabel.text = "Unavailable"
        }
        
        if serviceTravelDuration == nil {
            serviceDetailWalkTimeLabel.text = "Unavailable"
        }
        
        // Services Tab Info
        servicesInfoNameLabel.text = serviceDetail?.name
        serviesInfoTextView.text =
        """
        Social Services
        Housing
        Medical
        Respite Bed Program
        Community Groups
        """
            
            
            
//        if let servicesJSON = serviceDetail?.services {
//            serviesInfoTextView.text = servicesJSON as? String
//        }
        
        
        // Details Tab Info
        detailsNameLabel.text = serviceDetail?.name
        detailsTextView.text =
        """
        Valid ID required
        Please call ahead
        Pets not allowed
        """
        
//        if let detailsJSON = serviceDetail?.details {
//            detailsTextView.text = detailsJSON as? String
//        }
    }
    
    // MARK: - Segmented Control Actions
    
    @IBAction func locationTapped(_ sender: Any) {
        detailsView.isHidden = true
        serviceView.isHidden = true
        infoView.isHidden = false
        
        locationButton.layer.addBorder(edge: .bottom, color: .white, thickness: 3)
        detailsButton.layer.addBorder(edge: .bottom, color: .customDarkPurple, thickness: 3)
        servicesButton.layer.addBorder(edge: .bottom, color: .customDarkPurple, thickness: 3)
        
        locationButton.titleLabel?.font = Appearance.mediumFont
        servicesButton.titleLabel?.font = Appearance.regularFont
        detailsButton.titleLabel?.font = Appearance.regularFont
        
        locationButton.setTitleColor(.white, for: .normal)
        servicesButton.setTitleColor(.customLightestGray, for: .normal)
        detailsButton.setTitleColor(.customLightestGray, for: .normal)
        
        
        updateViews()
    }
    
    @IBAction func servicesTapped(_ sender: Any) {
        detailsView.isHidden = true
        serviceView.isHidden = false
        infoView.isHidden = true
        
        servicesButton.layer.addBorder(edge: .bottom, color: .white, thickness: 3)
        detailsButton.layer.addBorder(edge: .bottom, color: .customDarkPurple, thickness: 3)
        locationButton.layer.addBorder(edge: .bottom, color: .customDarkPurple, thickness: 3)
        
        servicesButton.titleLabel?.font = Appearance.mediumFont
        locationButton.titleLabel?.font = Appearance.regularFont
        detailsButton.titleLabel?.font = Appearance.regularFont
        
        servicesButton.setTitleColor(.white, for: .normal)
        locationButton.setTitleColor(.customLightestGray, for: .normal)
        detailsButton.setTitleColor(.customLightestGray, for: .normal)
        
        updateViews()
    }
    
    @IBAction func detailsTapped(_ sender: Any) {
        detailsView.isHidden = false
        serviceView.isHidden = true
        infoView.isHidden = true
        
        detailsButton.layer.addBorder(edge: .bottom, color: .white, thickness: 3)
        servicesButton.layer.addBorder(edge: .bottom, color: .customDarkPurple, thickness: 3)
        locationButton.layer.addBorder(edge: .bottom, color: .customDarkPurple, thickness: 3)
        
        detailsButton.titleLabel?.font = Appearance.mediumFont
        locationButton.titleLabel?.font = Appearance.regularFont
        servicesButton.titleLabel?.font = Appearance.regularFont
        
        detailsButton.setTitleColor(.white, for: .normal)
        locationButton.setTitleColor(.customLightestGray, for: .normal)
        servicesButton.setTitleColor(.customLightestGray, for: .normal)
        
        updateViews()
    }
    
    @IBAction func spanishButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "La traducción al español vendrá pronto.", message: "Spanish translation coming soon.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    // MARK: - UI Search Bar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        filterServiceResults()

        performSegue(withIdentifier: "backToAllResultsSegue", sender: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func filterServiceResults() {
        // Grab the text, make sure it's not empty
        guard let searchTerm = self.searchBar.text, !searchTerm.isEmpty else {
            return
        }
        
        networkController?.searchTerm = searchTerm
        
        let matchingObjects = NetworkController.filteredObjects.filter({ $0.keywords.contains(searchTerm.lowercased()) || $0.name.contains(searchTerm.lowercased()) })
        
        networkController?.subcategoryDetails = matchingObjects
    }
    
    // MARK: - Location & Maps Management
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            serviceCoordinates = manager.location?.coordinate
            locationManager.stopUpdatingLocation()
        } else {
            print("User location is unavailable")
        }
        getServiceDistanceAndDuration()
        updateViews()
    }
    
    @IBAction func launchMapsButton(_ sender: Any) {
        
        // Form Directions URL
        // https://www.google.com/maps/dir/?api=1 // &parameters
        // https://www.google.com/maps/dir/?api=1&origin=Space+Needle+Seattle+WA&destination=Pike+Place+Market+Seattle+WA&travelmode=walking
        // https://www.google.com/maps/dir/?api=1&origin=40.7829,73.9654&destination=Pike+Place+Market+Seattle+WA&travelmode=walking
        // origin: if none, the map will provide a blank form to allow a user to enter the origin // OPTIONAL
        // destination: comma-separated latitude/longitude coordinates
        // travelmode (optional): driving, walking, bicycling, transit
        
        guard let unwrappedServiceCoordinate = serviceCoordinates else { return }
        
        print("Launch Google Maps URL: https://www.google.com/maps/dir/?api=1&origin=\(unwrappedServiceCoordinate.latitude),\(unwrappedServiceCoordinate.longitude)&destination=\(serviceDetail!.latitude!),\(serviceDetail!.longitude!)&travelmode=transit")
        
        if let url = URL(string: "https://www.google.com/maps/dir/?api=1&origin=\(unwrappedServiceCoordinate.latitude),\(unwrappedServiceCoordinate.longitude)&destination=\(serviceDetail!.latitude!),\(serviceDetail!.longitude!)&travelmode=transit") {
     
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    private func getServiceDistanceAndDuration() {
        
        guard let unwrappedServiceCoordinate = serviceCoordinates,
            let unwrappedDestLatitude  = NumberFormatter().number(from: (serviceDetail?.latitude)!)?.doubleValue,
            let unwrappedDestLongitude = NumberFormatter().number(from: (serviceDetail?.longitude)!)?.doubleValue else { return }
        
        googleMapsController?.fetchServiceDistance(unwrappedServiceCoordinate.latitude, unwrappedServiceCoordinate.longitude, unwrappedDestLatitude, unwrappedDestLongitude) { (error) in
            if let error = error {
                print("Error fetching distance to chosen service: \(error)")
            }
            
            self.serviceDistance = self.googleMapsController?.serviceDistance
            self.serviceTravelDuration = self.googleMapsController?.serviceTravelDuration
            
            print("serviceDistance: \(String(describing: self.serviceDistance))")
            print("serviceTravelDuration: \(String(describing: self.serviceTravelDuration))")
            
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToAllResultsSegue" {
            let destination = segue.destination as! ServiceResultsViewController
            destination.networkController = networkController
        }
    }
    
    func setupTheme() {
        
        // Button
        startMapButton.setTitle("  Start Map", for: .normal)
        startMapButton.setTitleColor(.white, for: .normal)
        startMapButton.backgroundColor = .customDarkPurple
        
        let nearMeColoredIcon = UIImage(named: "near_me")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        startMapButton.tintColor = UIColor.white
        startMapButton.setImage(nearMeColoredIcon, for: .normal)
        mapView.layer.borderWidth = 0.5
        mapView.layer.borderColor = UIColor.gray.cgColor
        
        // Segmented Control
        segmentButtonView.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
        locationButton.setTitle("LOCATION", for: .normal)
        locationButton.setTitleColor(.white, for: .normal)
        locationButton.titleLabel?.font = Appearance.mediumFont // when selected, regular when not selected
        locationButton.backgroundColor = .customDarkPurple
        
        servicesButton.setTitle("SERVICES", for: .normal)
        servicesButton.setTitleColor(.customLightestGray, for: .normal)
        servicesButton.titleLabel?.font = Appearance.regularFont // when not selected, regular when elected
        servicesButton.backgroundColor = .customDarkPurple
        
        detailsButton.setTitle("DETAILS", for: .normal)
        detailsButton.setTitleColor(.customLightestGray, for: .normal)
        detailsButton.titleLabel?.font = Appearance.regularFont // when not selected, regular when elected
        detailsButton.backgroundColor = .customDarkPurple
        
        infoView.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
        detailsView.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
        serviceView.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
        
        //servicesInfoNameLabel.setLabelShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
        //serviceDetailNameLabel.setLabelShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
        
        // Fonts
        serviceDetailNameLabel.font = Appearance.scaledNameLabelFont(with: .title1, size: 36)
        serviceDetailNameLabel.textColor = UIColor.customLightBlack
        serviceDetailAddressLabel.font = Appearance.lightFont
        serviceDetailDistanceLabel.font = Appearance.lightFont
        serviceDetailWalkTimeLabel.font = Appearance.lightFont
        serviceDetailPhoneLabel.font = Appearance.lightFont
        serviceDetailHoursLabel.font = Appearance.lightFont
        
        servicesInfoNameLabel.font = Appearance.scaledNameLabelFont(with: .title1, size: 36)
        servicesInfoNameLabel.textColor = .customLightBlack
        serviesInfoTextView.font = Appearance.lightFont
        
        detailsNameLabel.font = Appearance.scaledNameLabelFont(with: .title1, size: 36)
        detailsNameLabel.textColor = .customLightBlack
        detailsTextView.font = Appearance.lightFont
        
        // Icon Colors
        let placeColoredIcon = UIImage(named: "place")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        addressIconImageView.tintColor = .customDarkPurple
        addressIconImageView.image = placeColoredIcon
        
        let busColoredIcon = UIImage(named: "bus")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        transitIconImageView.tintColor = .customDarkPurple
        transitIconImageView.image = busColoredIcon
        
        let walkColoredIcon = UIImage(named: "walk")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        walkIconImageView.tintColor = .customDarkPurple
        walkIconImageView.image = walkColoredIcon
        
        let phoneColoredIcon = UIImage(named: "phone")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        phoneIconImageView.tintColor = .customDarkPurple
        phoneIconImageView.image = phoneColoredIcon
        
        let clockColoredIcon = UIImage(named: "clock")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        hoursIconImageView.tintColor = .customDarkPurple
        hoursIconImageView.image = clockColoredIcon
        
        // Info View Borders
        infoTravelView.layer.borderColor = UIColor.lightGray.cgColor
        infoTravelView.layer.borderWidth = 0.25
        infoAddressView.layer.borderColor = UIColor.lightGray.cgColor
        infoAddressView.layer.borderWidth = 0.25
        infoPhoneView.layer.borderColor = UIColor.lightGray.cgColor
        infoPhoneView.layer.borderWidth = 0.25
        infoHoursView.layer.borderColor = UIColor.lightGray.cgColor
        infoHoursView.layer.borderWidth = 0.25
    }

}
