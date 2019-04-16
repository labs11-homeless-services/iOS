//
//  ServiceDetailViewController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/29/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit
import GoogleMaps

class ServiceDetailViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    // Outlet for MapView
    @IBOutlet weak var mapView: GMSMapView!
    

    
    // MARK: Info View Outlets
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var serviceDetailNameLabel: UILabel!
    @IBOutlet weak var serviceDetailAddressLabel: UILabel!
    @IBOutlet weak var serviceDetailDistanceLabel: UILabel!
    @IBOutlet weak var serviceDetailWalkTimeLabel: UILabel!
    @IBOutlet weak var serviceDetailPhoneLabel: UILabel!
    @IBOutlet weak var serviceDetailHoursLabel: UILabel!
    
    // MARK: Service View Outlets
    @IBOutlet weak var serviceView: UIView!
    @IBOutlet weak var servicesInfoNameLabel: UILabel!
    @IBOutlet weak var serviesInfoTextView: UITextView!
    
    // MARK: Detail View Outlets
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var detailsNameLabel: UILabel!
    @IBOutlet weak var detailsTextView: UITextView!
    
    // MARK: - Segmented Control Actions
    @IBAction func locationTapped(_ sender: Any) {
        detailsView.isHidden = true
        serviceView.isHidden = true
        infoView.isHidden = false
        updateViews()
    }
    
    @IBAction func servicesTapped(_ sender: Any) {
        detailsView.isHidden = true
        serviceView.isHidden = false
        infoView.isHidden = true
        updateViews()
    }
    
    @IBAction func detailsTapped(_ sender: Any) {
        detailsView.isHidden = false
        serviceView.isHidden = true
        infoView.isHidden = true
        updateViews()
    }
    
    //var resultLatitude = navigationController

    var serviceDistance: String!
    var serviceTravelDuration: String!
    
    var serviceCoordinates: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    
    let googleMapsController = GoogleMapsController()
    var networkController: NetworkController?
    
    var serviceDetail: IndividualResource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoView.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
        detailsView.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
        serviceView.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
        
        servicesInfoNameLabel.setLabelShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
        serviceDetailNameLabel.setLabelShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
        
        detailsView.isHidden = true
        serviceView.isHidden = true
        infoView.isHidden = false
        
        self.title = serviceDetail?.name
        
        mapView.delegate = self
        
        // Convert latitude/longitude strings to doubles
        if serviceDetail?.latitude == nil || serviceDetail?.longitude == nil {
            return
            // If there is not latitude and longitude in service details:
            // We could show a message and say map unavailable
            // Then show the user's location.
        } else {
            guard let doubleLatValue = NumberFormatter().number(from: (serviceDetail?.latitude)!)?.doubleValue,
                let doubleLongValue = NumberFormatter().number(from: (serviceDetail?.longitude)!)?.doubleValue
                else {
                    print("Latitude or Longitude is not a valid Double")
                    return
            }
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: doubleLatValue, longitude: doubleLongValue)
            marker.title = serviceDetail?.address
            marker.map = mapView
            
            mapView.camera = GMSCameraPosition(target: marker.position, zoom: 13, bearing: 0, viewingAngle: 0)
            
        }
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            serviceCoordinates = manager.location?.coordinate
            print("serviceCoordinates: \(serviceCoordinates)")
            locationManager.stopUpdatingLocation()
        } else {
            print("User location is unavailable")
        }
        getServiceDistanceAndDuration()
        updateViews()
    }
    
    func updateViews() {

        serviceDetailNameLabel.text = serviceDetail?.name
        serviceDetailAddressLabel.text = serviceDetail?.address
        
        if let phoneJSON = serviceDetail?.phone {
            serviceDetailPhoneLabel.text = phoneJSON as? String
        }
        //serviceDetailPhoneLabel.text = serviceDetail?.phone
        serviceDetailHoursLabel.text = serviceDetail?.hours
        
        guard let unwrappedDistance = serviceDistance,
            let unwrappedDuration = serviceTravelDuration else { return }
        serviceDetailDistanceLabel.text = unwrappedDistance
        serviceDetailWalkTimeLabel.text = unwrappedDuration
        // Services Tab Info
        servicesInfoNameLabel.text = serviceDetail?.name
        serviesInfoTextView.text = """
        GED Prep Courses
        """
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
        
        googleMapsController.fetchServiceDistance(unwrappedServiceCoordinate.latitude, unwrappedServiceCoordinate.longitude, unwrappedDestLatitude, unwrappedDestLongitude) { (error) in
            if let error = error {
                print("Error fetching distance to chosen service: \(error)")
            }
            
            self.serviceDistance = self.googleMapsController.serviceDistance
            self.serviceTravelDuration = self.googleMapsController.serviceTravelDuration
            
            print("serviceDistance: \(String(describing: self.serviceDistance))")
            print("serviceTravelDuration: \(String(describing: self.serviceTravelDuration))")
            
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
        
    }

}
