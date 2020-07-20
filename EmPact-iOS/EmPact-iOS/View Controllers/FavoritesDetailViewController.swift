//
//  FavoritesDetailViewController.swift
//  EmPact-iOS
//
//  Created by Jonah  on 6/27/20.
//  Copyright © 2020 EmPact. All rights reserved.
//

import UIKit
import GoogleMaps

class FavoritesDetailViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
       // MARK: - Outlet for MapView
       @IBOutlet weak var mapView: GMSMapView!
       
       // MARK: - Custom Segment Control Buttons
       @IBOutlet weak var segmentButtonView: UIView!
       @IBOutlet weak var locationButton: UIButton!
       @IBOutlet weak var servicesButton: UIButton!
       @IBOutlet weak var detailsButton: UIButton!
       
       // MARK: - Info View Outlets
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
       @IBOutlet weak var primaryServicesLabel: UILabel!
       @IBOutlet weak var serviesInfoTextView: UITextView!
       
       // MARK: Detail View Outlets
       @IBOutlet weak var detailsView: UIView!
       @IBOutlet weak var detailsNameLabel: UILabel!
       @IBOutlet weak var admissionDetailsLabel: UILabel!
       @IBOutlet weak var detailsTextView: UITextView!
       
       // MARK: - Map Unavailable Outlets
       @IBOutlet weak var mapUnavailableView: UIView!
       @IBOutlet weak var mapUnavailableLabel: UILabel!
       @IBOutlet weak var startMapButton: UIButton!
    
    var serviceDistance: String!
    var serviceTravelDuration: String!
    
    var serviceCoordinates: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    
    var googleMapsController: GoogleMapsController?
    var networkController: NetworkController?
    var cacheController: CacheController?
    
    //var serviceDetail: IndividualResource?
    var savedResource: SimpleResource?
    var tempResource: AnyObject?
    var selectedSubcategory: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        self.hideKeyboard()
        setupTheme()
        verifyCategoryData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    // MARK: - Segmented Control Actions - Display info in the Locations View
    @IBAction func locationTapped(_ sender: Any) {
        detailsView.isHidden = true
        serviceView.isHidden = true
        infoView.isHidden = false
        
        locationButton.layer.addBorder(edge: .bottom, color: .white, thickness: 3)
        detailsButton.layer.addBorder(edge: .bottom, color: .customDarkPurple, thickness: 3)
        servicesButton.layer.addBorder(edge: .bottom, color: .customDarkPurple, thickness: 3)
        
        locationButton.titleLabel?.font = Appearance.mediumFont
        servicesButton.titleLabel?.font = Appearance.smallRegularFont
        detailsButton.titleLabel?.font = Appearance.smallRegularFont
        
        locationButton.setTitleColor(.white, for: .normal)
        servicesButton.setTitleColor(.customLightestGray, for: .normal)
        detailsButton.setTitleColor(.customLightestGray, for: .normal)
        
        updateViews()
    }
    
    // MARK: - Action to display info in the Services View
    @IBAction func servicesTapped(_ sender: Any) {
        detailsView.isHidden = true
        serviceView.isHidden = false
        infoView.isHidden = true
        
        servicesButton.layer.addBorder(edge: .bottom, color: .white, thickness: 3)
        detailsButton.layer.addBorder(edge: .bottom, color: .customDarkPurple, thickness: 3)
        locationButton.layer.addBorder(edge: .bottom, color: .customDarkPurple, thickness: 3)
        
        servicesButton.titleLabel?.font = Appearance.mediumFont
        locationButton.titleLabel?.font = Appearance.smallRegularFont
        detailsButton.titleLabel?.font = Appearance.smallRegularFont
        
        servicesButton.setTitleColor(.white, for: .normal)
        locationButton.setTitleColor(.customLightestGray, for: .normal)
        detailsButton.setTitleColor(.customLightestGray, for: .normal)
        
        updateViews()
    }
    
    // MARK: - Action to display info in the Details View
    @IBAction func detailsTapped(_ sender: Any) {
        detailsView.isHidden = false
        serviceView.isHidden = true
        infoView.isHidden = true
        
        detailsButton.layer.addBorder(edge: .bottom, color: .white, thickness: 3)
        servicesButton.layer.addBorder(edge: .bottom, color: .customDarkPurple, thickness: 3)
        locationButton.layer.addBorder(edge: .bottom, color: .customDarkPurple, thickness: 3)
        
        detailsButton.titleLabel?.font = Appearance.mediumFont
        locationButton.titleLabel?.font = Appearance.smallRegularFont
        servicesButton.titleLabel?.font = Appearance.smallRegularFont
        
        detailsButton.setTitleColor(.white, for: .normal)
        locationButton.setTitleColor(.customLightestGray, for: .normal)
        servicesButton.setTitleColor(.customLightestGray, for: .normal)
        
        updateViews()
    }
    
    // MARK: - Location & Maps Management
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        serviceCoordinates = manager.location?.coordinate
        if locations.first != nil {
            manager.stopUpdatingLocation()
        } else {
            NSLog("User location is unavailable")
        }
        getServiceDistanceAndDuration()
        updateViews()
    }
    
    // MARK: - Lauch Google Maps Action
    @IBAction func launchMapsButton(_ sender: Any) {
        
        guard let unwrappedServiceCoordinate = serviceCoordinates else { return }
        if let url = URL(string: "https://www.google.com/maps/dir/?api=1&origin=\(unwrappedServiceCoordinate.latitude),\(unwrappedServiceCoordinate.longitude)&destination=\(savedResource!.latitude!),\(savedResource!.longitude!)&travelmode=transit") {
            
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    // MARK: - Google Distance Matrix to get Walking Distance and Travel Duration
    private func getServiceDistanceAndDuration() {
        
        guard savedResource?.latitude != nil, savedResource?.longitude != nil
            else {
                NSLog("serviceDetail's latitude or longitude was nil")
                return
        }
        
        guard let unwrappedServiceCoordinate = serviceCoordinates,
            let unwrappedDestLatitude = NumberFormatter().number(from: savedResource?.latitude ?? ""),
            let unwrappedDestLongitude = NumberFormatter().number(from: savedResource?.longitude ?? "") else { return }
        
        googleMapsController?.fetchServiceDistance(unwrappedServiceCoordinate.latitude, unwrappedServiceCoordinate.longitude, Double(truncating: unwrappedDestLatitude), Double(truncating: unwrappedDestLongitude)) { (error) in
            if let error = error {
                NSLog("Error fetching distance to chosen service: \(error)")
            }
            
            self.serviceDistance = self.googleMapsController?.serviceDistance
            self.serviceTravelDuration = self.googleMapsController?.serviceTravelDuration
            
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }
    
    // MARK: - Update View's Information Method
    func updateViews() {
        
        serviceDetailNameLabel.text = savedResource?.name
        
        if savedResource?.address == nil || savedResource?.address == "" {
            serviceDetailAddressLabel.text = "Address Unavailable"
        } else {
            serviceDetailAddressLabel.text = savedResource?.address
        }
        
        if savedResource?.phone == nil {
            serviceDetailPhoneLabel.text = "Phone number unavailable"
        } else {
            serviceDetailPhoneLabel.text = savedResource?.phone
                
        }
        
        if savedResource?.hours == nil {
            serviceDetailHoursLabel.text = "Please call for hours"
        } else {
            serviceDetailHoursLabel.text = savedResource?.hours
        }
        
        // Services Tab Info
        servicesInfoNameLabel.text = savedResource?.name
        
        guard let services = savedResource?.services else { return }
        let tempServices = services
            .replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")
            .replacingOccurrences(of: "\"", with: "")
            .replacingOccurrences(of: ",", with: "\n")
        
        if tempServices == "" {
            serviesInfoTextView.text = "Please call for available services"
        } else {
            serviesInfoTextView.text = tempServices
        }
            
        // Details Tab Info
        detailsNameLabel.text = savedResource?.name
        
        guard let details = savedResource?.details else { return }
        let tempDetails = details
            .replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")
            .replacingOccurrences(of: "\"", with: "")
            .replacingOccurrences(of: ",", with: "\n")
        
        if tempDetails == "" {
            detailsTextView.text = "Please call for admission details"
        } else {
            detailsTextView.text = tempDetails
        }
        
        // Adjustable Font sizes
        servicesInfoNameLabel.adjustsFontSizeToFitWidth = true
        serviceDetailNameLabel.adjustsFontSizeToFitWidth = true
        serviceDetailAddressLabel.adjustsFontSizeToFitWidth = true
        serviceDetailDistanceLabel.adjustsFontSizeToFitWidth = true
        serviceDetailWalkTimeLabel.adjustsFontSizeToFitWidth = true
        serviceDetailPhoneLabel.adjustsFontSizeToFitWidth = true
        serviceDetailHoursLabel.adjustsFontSizeToFitWidth = true
        
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
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToAllResultsSegue" {
            let destination = segue.destination as! ServiceResultsViewController
            destination.networkController = networkController
            destination.cacheController = cacheController
        }
    }
    
    // MARK: - Appearance Theme Method
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
        segmentButtonView.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 1, height: 3), radius: 4, viewCornerRadius: 0)
        locationButton.setTitle("LOCATION", for: .normal)
        locationButton.setTitleColor(.white, for: .normal)
        locationButton.titleLabel?.font = Appearance.mediumFont // when selected, regular when not selected
        locationButton.backgroundColor = .customDarkPurple
        
        servicesButton.setTitle("SERVICES", for: .normal)
        servicesButton.setTitleColor(.customLightestGray, for: .normal)
        servicesButton.titleLabel?.font = Appearance.smallRegularFont // when not selected, regular when elected
        servicesButton.backgroundColor = .customDarkPurple
        
        detailsButton.setTitle("DETAILS", for: .normal)
        detailsButton.setTitleColor(.customLightestGray, for: .normal)
        detailsButton.titleLabel?.font = Appearance.smallRegularFont // when not selected, regular when elected
        detailsButton.backgroundColor = .customDarkPurple
        
        infoView.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 1, height: 3), radius: 4, viewCornerRadius: 0)
        detailsView.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 1, height: 3), radius: 4, viewCornerRadius: 0)
        serviceView.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 1, height: 3), radius: 4, viewCornerRadius: 0)
        
        // Fonts
        serviceDetailNameLabel.font = Appearance.scaledNameLabelFont(with: .title1, size: 40)
        serviceDetailNameLabel.textColor = UIColor.customLightBlack
        serviceDetailAddressLabel.font = Appearance.lightFont
        serviceDetailDistanceLabel.font = Appearance.lightFont
        serviceDetailWalkTimeLabel.font = Appearance.lightFont
        serviceDetailPhoneLabel.font = Appearance.lightFont
        serviceDetailHoursLabel.font = Appearance.lightFont
        
        servicesInfoNameLabel.font = Appearance.scaledNameLabelFont(with: .title1, size: 40)
        servicesInfoNameLabel.textColor = .customLightBlack
        primaryServicesLabel.textColor = .customDarkPurple
        serviesInfoTextView.font = Appearance.serviceAndDetailFont
        serviesInfoTextView.textColor = .customLightBlack
        
        detailsNameLabel.font = Appearance.scaledNameLabelFont(with: .title1, size: 40)
        detailsNameLabel.textColor = .customLightBlack
        admissionDetailsLabel.textColor = .customDarkPurple
        detailsTextView.font = Appearance.serviceAndDetailFont
        detailsTextView.textColor = UIColor.customLightBlack
        
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
        
        detailsView.isHidden = true
        serviceView.isHidden = true
        infoView.isHidden = false
        mapUnavailableView.isHidden = true
        mapUnavailableView.alpha = 0.75
        mapUnavailableLabel.isHidden = true
        mapUnavailableView.backgroundColor = .customDarkPurple
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        if savedResource?.latitude == nil || savedResource?.latitude == "" || savedResource?.longitude == nil || savedResource?.longitude == "" {
            mapUnavailableView.isHidden = false
            mapUnavailableLabel.isHidden = false
            mapUnavailableLabel.textColor = .white
            
            startMapButton.isHidden = true
            serviceDetailDistanceLabel.text = "Unavailable"
            serviceDetailWalkTimeLabel.text = "Unavailable"
            
            let camera = GMSCameraPosition.camera(withLatitude: 40.7829, longitude: -73.9654, zoom: 14.0)
            mapView.camera = camera
            
        } else {
            guard let doubleLatValue = NumberFormatter().number(from: (savedResource?.latitude)!)?.doubleValue,
                let doubleLongValue = NumberFormatter().number(from: (savedResource?.longitude)!)?.doubleValue
                else {
                    NSLog("Latitude or Longitude is not a valid Double")
                    return
            }
            
            // MARK: - Embedded Map
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: doubleLatValue, longitude: doubleLongValue)
            
            marker.title = savedResource?.name
            mapView.selectedMarker = marker
            marker.appearAnimation = .pop
            marker.map = mapView
            
            mapView.camera = GMSCameraPosition(target: marker.position, zoom: 13, bearing: 0, viewingAngle: 0)
            
        }
        locationButton.layer.addBorder(edge: .bottom, color: .white, thickness: 3)
        DispatchQueue.main.async {
            self.updateViews()
            
        }
    }
    
    private func verifyCategoryData() {
        if networkController?.tempCategorySelection == "" || networkController?.tempCategorySelection == nil {
            self.title = savedResource?.name
        } else if selectedSubcategory == "" || selectedSubcategory == nil {
            self.title = savedResource?.name
        } else {
            guard let unwrappedTempCategorySelection = networkController?.tempCategorySelection else { return }
            self.title = "\(unwrappedTempCategorySelection) - \(selectedSubcategory.capitalized)"
        }
    }
}



