//
//  ServiceDetailViewController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/29/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ServiceDetailViewController: UIViewController {
    
    // Outlet for MapView
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var serviceDetailNameLabel: UILabel!
    @IBOutlet weak var serviceDetailAddressLabel: UILabel!
    @IBOutlet weak var serviceDetailDistanceLabel: UILabel!
    @IBOutlet weak var serviceDetailWalkTimeLabel: UILabel!
    @IBOutlet weak var serviceDetailPhoneLabel: UILabel!
    @IBOutlet weak var serviceDetailHoursLabel: UILabel!
    
    //var resultLatitude = navigationController
    
    var serviceCoordinates: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    let annotation = MKPointAnnotation()
    
    var networkController: NetworkController?
    let googleMapsController = GoogleMapsController()
    
    var shelterServiceDetail: ShelterIndividualResource?
    var serviceDetail: IndividualResource?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = serviceDetail?.name
        
        //getServiceDistanceAndDuration()
        let unwrappedLatitude = serviceCoordinates?.latitude
            let unwrappedLongitude = serviceCoordinates?.longitude
        print("locations = \(unwrappedLatitude) \(unwrappedLongitude)")
        
        if serviceDetail?.latitude == nil || serviceDetail?.longitude == nil {
            return
            // Create a hidden label
            // If not location is present
            // Set label is hidden bool to false
            // label says "map is unavailable for your desired location"
            
            //serviceDetail?.latitude = String(40.7829)
            //serviceDetail?.longitude = String(73.9654)
            
        } else {
            guard let doubleLatValue = NumberFormatter().number(from: (serviceDetail?.latitude)!)?.doubleValue,
                let doubleLongValue = NumberFormatter().number(from: (serviceDetail?.longitude)!)?.doubleValue
                else {
                    print("Latitude or Longitude is not a valid Double")
                    return
            }
            
            let center = CLLocationCoordinate2D(latitude: doubleLatValue, longitude: doubleLongValue)
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
            
            // Change to default to Central Park if no coordinates are retrieved from JSON
            annotation.coordinate = CLLocationCoordinate2D(latitude: doubleLatValue,
                                                           longitude: doubleLongValue)
            mapView.addAnnotation(annotation)
        }
        
        updateViews()
    }
    
    // MARK: - Google Distance Matrix Method
    private func getServiceDistanceAndDuration() {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            //locationManager.desiredAccuracy =
            locationManager.startUpdatingLocation()
        }
        
        googleMapsController.fetchServiceDistance((serviceCoordinates?.latitude)!, (serviceCoordinates?.longitude)!, 40.6905615, -73.9976592) { (error) in
            if let error = error {
                print("Error fetching distance to chosen service: \(error)")
            }
            
            guard let unwrappedDistance = self.googleMapsController.serviceDistance,
                let unwrappedDuration = self.googleMapsController.serviceTravelDuration else { return }
            
            print("serviceDistance: \(String(describing: unwrappedDistance))")
            print("serviceTravelDuration: \(String(describing: unwrappedDuration))")
        }
        
    }
    
    func updateViews() {
        serviceDetailNameLabel.text = serviceDetail?.name
        serviceDetailAddressLabel.text = serviceDetail?.address
        //serviceDetailDistanceLabel.text =
        //serviceDetailWalkTimeLabel.text =
        serviceDetailPhoneLabel.text = serviceDetail?.phone
        serviceDetailHoursLabel.text = serviceDetail?.hours
        
    }

}

// MARK: - Google Distance Matrix Extension
extension ServiceDetailViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        serviceCoordinates = manager.location?.coordinate
    }
}
