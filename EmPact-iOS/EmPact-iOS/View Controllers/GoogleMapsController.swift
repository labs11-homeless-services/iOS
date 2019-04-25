//
//  GoogleMapsController.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/10/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

class GoogleMapsController {
    
    var googleDistanceResponse: [Row]!
    var serviceAddresses: [String]!
    var serviceDistance: String!
    var serviceTravelDuration: String!
    
    var originLatitude: Double = 0
    var originLongitude: Double = 0
    var destinationLatitude: Double = 0
    var destinationLongitude: Double = 0
    
    typealias CompletionHandler = (Error?) -> Void
    static var baseURL: URL! { return URL( string: "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial" ) }
    
    func fetchServiceDistance(_ originLatitude: Double,
                              _ originLongitude: Double,
                              _ destinationLatitude: Double,
                              _ destinationLongitude: Double,
                              completion: @escaping CompletionHandler = { _ in }) {
        
        let originString = String(originLatitude) + "," + String(originLongitude)
        let destinationString = String(destinationLatitude) + "," + String(destinationLongitude)
        guard var components = URLComponents(url: GoogleMapsController.baseURL, resolvingAgainstBaseURL: true) else {
            fatalError("Unable to resolve baseURL to components")
        }
            let queryItemImperial = URLQueryItem(name: "units", value: "imperial")
            let queryItemOrigin = URLQueryItem(name: "origins", value: originString)
            let queryItemDestination = URLQueryItem(name: "destinations", value: destinationString)
            let queryItemTravelMode = URLQueryItem(name: "mode", value:"walking")
            let queryItemKey = URLQueryItem(name: "key", value: apiKey)
        
        components.queryItems = [queryItemImperial, queryItemOrigin, queryItemDestination, queryItemTravelMode, queryItemKey]
        let requestURL = components.url
        print("requestURL: \(requestURL)")
        
        URLSession.shared.dataTask(with: requestURL!) { ( data, _, error) in
            if let error = error {
                NSLog("error fetching tasks: \(error)")
                completion(error)
                return
            }
            guard let data = data else {
                NSLog("no data returned from data task.")
                completion(NSError())
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse = try jsonDecoder.decode(GoogleDistance.self, from: data)
                let googleDistanceResponse = decodedResponse.rows
                self.serviceDistance = googleDistanceResponse[0].elements[0].distance.text
                self.serviceTravelDuration = googleDistanceResponse[0].elements[0].duration.text
                
                self.serviceAddresses = decodedResponse.destinationAddresses
                
                completion(nil)
            } catch {
                completion(error)
            }
            }.resume()
    }
    

    func fetchNearestShelter(_ originLatitude: Double,
                             _ originLongitude: Double,
                             completion: @escaping CompletionHandler = { _ in }) {
        
        let originString = String(originLatitude) + "," + String(originLongitude)
        let destinationString = "120+East+32nd+Street+New+York+NY+10016|800+Barretto+St+The+Bronx+NY+10474|257+West+30th+Street+New+York+NY+10001|2402+Atlantic+Avenue|25+Central+Avenue|703+Lexington+Avenue+Brooklyn+NY+11221|2402+Atlantic+Avenue|550+10th+Avenue+New+York+NY+10018"
        
        guard var components = URLComponents(url: GoogleMapsController.baseURL, resolvingAgainstBaseURL: true) else {
            fatalError("Unable to resolve baseURL to components")
        }
        let queryItemImperial = URLQueryItem(name: "units", value: "imperial")
        let queryItemOrigin = URLQueryItem(name: "origins", value: originString)
        let queryItemDestination = URLQueryItem(name: "destinations", value: destinationString)
        let queryItemTravelMode = URLQueryItem(name: "mode", value:"walking")
        let queryItemKey = URLQueryItem(name: "key", value: "\(apiKey)")
        
        components.queryItems = [queryItemImperial, queryItemOrigin, queryItemDestination, queryItemTravelMode, queryItemKey]
        guard let requestURL = components.url else { return }
        
        URLSession.shared.dataTask(with: requestURL) { ( data, _, error) in
            if let error = error {
                NSLog("error fetching tasks: \(error)")
                completion(error)
                return
            }
            guard let data = data else {
                NSLog("no data returned from data task.")
                completion(NSError())
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse = try jsonDecoder.decode(GoogleDistance.self, from: data)
                
                self.googleDistanceResponse = decodedResponse.rows
                self.serviceDistance = self.googleDistanceResponse[0].elements[0].distance.text
                self.serviceTravelDuration = self.googleDistanceResponse[0].elements[0].duration.text
                self.serviceAddresses = decodedResponse.destinationAddresses
                
                completion(nil)
            } catch {
                completion(error)
            }
            }.resume()
    }
}
