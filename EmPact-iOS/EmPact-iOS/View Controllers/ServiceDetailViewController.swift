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
    var mapView: MKMapView!
    //var resultLatitude = navigationController
    
    let annotation = MKPointAnnotation()
    
    var networkController: NetworkController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        annotation.coordinate = CLLocationCoordinate2D(latitude: 11.12, // These will be fetched from Firebase
                                                       longitude: 12.11)
        mapView.addAnnotation(annotation)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
