//
//  ServiceDetailViewController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/29/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit
import MapKit

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
    
    let annotation = MKPointAnnotation()
    
    var networkController: NetworkController?
    
    var shelterServiceDetail: ShelterIndividualResource?
    var serviceDetail: IndividualResource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = serviceDetail?.name
        
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
    
    func updateViews() {
        serviceDetailNameLabel.text = serviceDetail?.name
        serviceDetailAddressLabel.text = serviceDetail?.address
        //serviceDetailDistanceLabel.text =
        //serviceDetailWalkTimeLabel.text =
        serviceDetailPhoneLabel.text = serviceDetail?.phone
        serviceDetailHoursLabel.text = serviceDetail?.hours
        
    }



}
