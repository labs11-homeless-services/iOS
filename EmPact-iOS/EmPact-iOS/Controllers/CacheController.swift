
//
//  CacheController.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/15/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

class CacheController {
    
    static var cache = NSCache<NSString, IndividualResource>()
    static var resourceObject: IndividualResource?
    
    // MARK: - Properties for FetchAll
    
    static var allShelterObjects: [IndividualResource] = []
    static var allEducationObjects: [IndividualResource] = []
    static var allLegalAdminObjects: [IndividualResource] = []
    static var allHealthCareObjects: [IndividualResource] = []
    static var allFoodObjects: [IndividualResource] = []
    static var allHygieneObjects: [IndividualResource] = []
    static var allJobsObjects: [IndividualResource] = []
    static var allOutreachServicesObjects: [IndividualResource] = []
    
    static var filteredObjects: [IndividualResource] = []
    
    typealias CompletionHandler = (Error?) -> Void
    
    static func fetchAllForSearch(completion: @escaping CompletionHandler = { _ in }) {
        
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
                
                print(decodedResponse.healthCare.clinics)
                
                self.allShelterObjects = decodedResponse.shelters.all
                self.allEducationObjects = decodedResponse.education.all
                self.allLegalAdminObjects = decodedResponse.legalAdministrative.all
                self.allHealthCareObjects = decodedResponse.healthCare.all
                self.allFoodObjects = decodedResponse.food.all
                self.allHygieneObjects = decodedResponse.hygiene.all
                self.allOutreachServicesObjects = decodedResponse.outreachServices._all
                
                for eachObject in allShelterObjects {
                    filteredObjects.append(eachObject)
                }
                
                for eachObject in allEducationObjects {
                    filteredObjects.append(eachObject)
                }
                
                for eachObject in allLegalAdminObjects {
                    filteredObjects.append(eachObject)
                }
                
                for eachObject in allHealthCareObjects {
                    filteredObjects.append(eachObject)
                }
                
                for eachObject in allFoodObjects {
                    filteredObjects.append(eachObject)
                }
                
                for eachObject in allHygieneObjects {
                    filteredObjects.append(eachObject)
                }
                
                for eachObject in allOutreachServicesObjects {
                    filteredObjects.append(eachObject)
                }
                
                
//                for eachObject in self.allShelterObjects {
//
//                    var keywordStringsArray = eachObject.keywords.components(separatedBy: ", ")
//                    print(keywordStringsArray)
//
//                    for eachKeyword in keywordStringsArray {
//                        self.cache.setObject( eachObject, forKey: eachKeyword as NSString )
//                    }
//                }
//
//                print(self.cache.object(forKey: "shelter")?.address)
//                print(self.cache.object(forKey: "drop-in")?.address)

                completion(nil)
            } catch {
                NSLog("Error decoding FirebaseObject: \(error)")
                completion(error)
            }
        }.resume()
        
    }
    
}

//extension IndividualResource {
//    func matches(searchTerm: String) -> Bool {
//        return keywords.contains(where: { $0.contains(newSearchText) })
//    }
//}

