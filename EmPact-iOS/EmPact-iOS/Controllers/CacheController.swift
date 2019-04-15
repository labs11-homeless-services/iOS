
//
//  CacheController.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/15/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

class CacheController {
    
    var cache = NSCache<NSString, IndividualResource>()
    var resourceObject: IndividualResource?
    
    // MARK: - Properties for FetchAll
    
    var allShelterObjects: [IndividualResource] = []
    var allEducationObjects: [IndividualResource] = []
    var allLegalAdminObjects: [IndividualResource] = []
    var allHealthCareObjects: [IndividualResource] = []
    var allFoodObjects: [IndividualResource] = []
    var allHygieneObjects: [IndividualResource] = []
    var allJobsObjects: [IndividualResource] = []
    var allOutreachServicesObjects: [IndividualResource] = []
    
    var filteredObjects: [IndividualResource] = []
    
    typealias CompletionHandler = (Error?) -> Void
    
    func fetchAllForSearch(completion: @escaping CompletionHandler = { _ in }) {
        
        let requestURL = NetworkController.baseURL
            .appendingPathExtension("json")
        
        print(requestURL)
        
        URLSession.shared.dataTask(with: requestURL) { ( data, _, error ) in
            if let error = error {
                NSLog("Error fetching data for search: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from fetch for search data task.")
                completion(NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                
                let decodedResponse = try jsonDecoder.decode(FirebaseObject.self, from: data)
                self.allShelterObjects = decodedResponse.shelters.all
                // All categories
                
                for eachObject in self.allShelterObjects {

                    self.cache.setObject( eachObject, forKey: eachObject.keywords as NSString )
                }
                
                //print(self.cache.object(forKey: "shelter, drop-in, meal, shower, help, bed"))

                completion(nil)
            } catch {
                NSLog("Error decoding FirebaseObject: \(error)")
                completion(error)
            }
            }.resume()
        
    }
    
}

