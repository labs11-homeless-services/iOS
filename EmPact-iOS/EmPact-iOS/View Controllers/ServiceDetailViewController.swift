//
//  ServiceDetailViewController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/29/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit
import GoogleMaps

class ServiceDetailViewController: UIViewController, GMSMapViewDelegate {
    
    // Outlet for MapView
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var serviceDetailNameLabel: UILabel!
    @IBOutlet weak var serviceDetailAddressLabel: UILabel!
    @IBOutlet weak var serviceDetailDistanceLabel: UILabel!
    @IBOutlet weak var serviceDetailWalkTimeLabel: UILabel!
    @IBOutlet weak var serviceDetailPhoneLabel: UILabel!
    @IBOutlet weak var serviceDetailHoursLabel: UILabel!
    
    //var resultLatitude = navigationController

    var networkController: NetworkController?
    
    var serviceDetail: ShelterDetailsIndividualResource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = serviceDetail?.name
        
        mapView.delegate = self
        
        // Convert latitude/longitude strings to doubles
        guard let doubleLatValue = NumberFormatter().number(from: (serviceDetail?.latitude)!)?.doubleValue,
            let doubleLongValue = NumberFormatter().number(from: (serviceDetail?.longitude)!)?.doubleValue
            else {
            print("Latitude or Longitude is not a valid Double")
            return
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: doubleLatValue, longitude: doubleLongValue, zoom: 12.0)
        mapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: doubleLatValue, longitude: doubleLongValue)
        marker.title = serviceDetail?.address
        marker.map = mapView
        
        // Change to default to Central Park if no coordinates are retrieved from JSON
        //annotation.coordinate = CLLocationCoordinate2D(latitude: doubleLatValue ?? 40.7829, longitude: doubleLongValue ?? 73.9654)
        
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
