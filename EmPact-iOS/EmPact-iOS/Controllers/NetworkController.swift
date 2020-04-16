//
//  NetworkController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/28/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class NetworkController {
    
    // MARK: - Properties
    
    var searchTerm = ""
    
    var tempSubcategorySelection = ""
    var subcategoryAtIndexPath: Subcategory!
    
    var tempCategorySelection = ""
    var subcategoryName = ""
    
    var categoryNames: [String] = []
    var subcategoryNames: [String] = []
    
    var tempCategoryDictionary: [String: [Any]] = [:]
    var tempSimpleDictionary: [String: Any] = [:]
    
    var subcategoryDetails: [IndividualResource] = []
    
    typealias CompletionHandler = (Error?) -> Void
    typealias Handler = ([String], Error?) -> Void
    static var baseURL: URL!  { return URL(string: "https://empact-e511a.firebaseio.com/") }
    
    // MARK: - Category Fetch
    
    // CATEGORY NAMES
    func fetchCategoryNames(completion: @escaping CompletionHandler = { _ in }) {
        
        let requestURL = NetworkController.baseURL
            .appendingPathComponent("categories")
            .appendingPathExtension("json")
        
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
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let decodedResponse = try jsonDecoder.decode(Categories.self, from: data)
                
                let categories = decodedResponse.categoryName
                let capitalizedCategories = categories.map {$0.capitalized}
                
                self.categoryNames = capitalizedCategories
                completion(nil)
            } catch {
                completion(error)
            }
        }.resume()
    }
    
    // MARK: - Subcategory Fetches
    
    // SUBCATEGORY NAMES
    func fetchSubcategoriesNames(_ category: Category, completion: @escaping Handler = { _, _ in }) {

        // Match rawValues to JSON
        let underscoredCategory = category.rawValue.replacingOccurrences(of: " ", with: "_").lowercased()
        
        let requestURL = NetworkController.baseURL
            .appendingPathComponent(underscoredCategory)
            .appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { ( data, _, error) in
            if let error = error {
                NSLog("error fetching tasks: \(error)")
                completion(self.subcategoryNames, error)
                return
            }
            
            guard let data = data else {
                NSLog("no data returned from data task.")
                completion(self.subcategoryNames, NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                // Switch on category to decode specific model object
                // Once decoded, loop through the dictionary in the model object and add the keys of the dictionary to our subcategoryNames array, which will be used to populate the hamburger menu
                switch category {
                case .education:
                    let decodedResponse = try jsonDecoder.decode(Education.self, from: data)
                    for decodedResponseDictionary in decodedResponse.dictionary {
                        self.subcategoryNames.append("\(decodedResponseDictionary.key)")
                        
                        self.tempCategoryDictionary = ["\(decodedResponseDictionary.key)": [decodedResponseDictionary.value]]
                    }
                case .legal:
                    let decodedResponse = try jsonDecoder.decode(LegalAdministrative.self, from: data)
                    for decodedResponseDictionary in decodedResponse.dictionary {
                        self.subcategoryNames.append("\(decodedResponseDictionary.key)")

                        self.tempCategoryDictionary = ["\(decodedResponseDictionary.key)": [decodedResponseDictionary.value]]
                    }
                case .food:
                    let decodedResponse = try jsonDecoder.decode(Food.self, from: data)
                    for decodedResponseDictionary in decodedResponse.dictionary {
                        self.subcategoryNames.append("\(decodedResponseDictionary.key)")
                        
                        self.tempCategoryDictionary = ["\(decodedResponseDictionary.key)": [decodedResponseDictionary.value]]
                    }
                case .healthCare:
                    let decodedResponse = try jsonDecoder.decode(HealthCare.self, from: data)
                    for decodedResponseDictionary in decodedResponse.dictionary {
                        self.subcategoryNames.append("\(decodedResponseDictionary.key)")
                        print(decodedResponseDictionary.key)

                        self.tempCategoryDictionary = ["\(decodedResponseDictionary.key)": [decodedResponseDictionary.value]]
                    }
                case .outreach:
                    let decodedResponse = try jsonDecoder.decode(OutreachServices.self, from: data)
                    for decodedResponseDictionary in decodedResponse.dictionary {
                        self.subcategoryNames.append("\(decodedResponseDictionary.key)")

                        self.tempCategoryDictionary = ["\(decodedResponseDictionary.key)": [decodedResponseDictionary.value]]
                    }
                case .hygiene:
                    let decodedResponse = try jsonDecoder.decode(Hygiene.self, from: data)
                    for decodedResponseDictionary in decodedResponse.dictionary {
                        self.subcategoryNames.append("\(decodedResponseDictionary.key)")
                        
                        self.tempCategoryDictionary = ["\(decodedResponseDictionary.key)": [decodedResponseDictionary.value]]
                    }
                case .shelters:
                    let decodedResponse = try jsonDecoder.decode(Shelters.self, from: data)
                    for decodedResponseDictionary in decodedResponse.dictionary {
                        self.subcategoryNames.append("\(decodedResponseDictionary.key)")
                        
                        self.tempCategoryDictionary = ["\(decodedResponseDictionary.key)": [decodedResponseDictionary.value]]
                    }
                case .jobs:
                    let decodedResponse = try jsonDecoder.decode(Jobs.self, from: data)
                    for decodedResponseDictionary in decodedResponse.dictionary {
                        self.subcategoryNames.append("\(decodedResponseDictionary.key)")
                        
                        self.tempCategoryDictionary = ["\(decodedResponseDictionary.key)": [decodedResponseDictionary.value]]
                    }
                }
                completion(self.subcategoryNames, nil)
            } catch {
                NSLog("error decoding entries: \(error)")
                completion(self.subcategoryNames, error)
            }
        }.resume()
    }
    
    func fetchSubcategoriesUnderscoredNames(_ category: UnderscoredCategory, completion: @escaping Handler = { _, _ in }) {
        
        var newCategoryName = ""
        
        if category.rawValue == "health care" {
            newCategoryName = "health_care"
        } else if category.rawValue == "legal administrative" {
            newCategoryName = "legal_administrative"
        } else if category.rawValue == "outreach services" {
            newCategoryName = "outreach_services"
        }
       
        let requestURL = NetworkController.baseURL
            .appendingPathComponent("\(newCategoryName)")
            .appendingPathExtension("json")
        
        print(requestURL)
        
        URLSession.shared.dataTask(with: requestURL) { ( data, _, error) in
            if let error = error {
                NSLog("error fetching tasks: \(error)")
                completion(self.subcategoryNames, error)
                return
            }
            
            guard let data = data else {
                NSLog("no data returned from data task.")
                completion(self.subcategoryNames, NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                
                switch category {

                case .legal:
                    let decodedResponse = try jsonDecoder.decode(LegalAdministrative.self, from: data)
                    for decodedResponseDictionary in decodedResponse.dictionary {
                        self.subcategoryNames.append("\(decodedResponseDictionary.key)")
                        
                        self.tempCategoryDictionary = ["\(decodedResponseDictionary.key)": [decodedResponseDictionary.value]]
                    }
                case .healthCare:
                    let decodedResponse = try jsonDecoder.decode(HealthCare.self, from: data)
                    for decodedResponseDictionary in decodedResponse.dictionary {
                        self.subcategoryNames.append("\(decodedResponseDictionary.key)")
                        
                        self.tempCategoryDictionary = ["\(decodedResponseDictionary.key)": [decodedResponseDictionary.value]]
                    }
                case .outreach:
                    let decodedResponse = try jsonDecoder.decode(OutreachServices.self, from: data)
                    for decodedResponseDictionary in decodedResponse.dictionary {
                        self.subcategoryNames.append("\(decodedResponseDictionary.key)")
                        
                        self.tempCategoryDictionary = ["\(decodedResponseDictionary.key)": [decodedResponseDictionary.value]]
                    }
                }
                completion(self.subcategoryNames, nil)
            } catch {
                NSLog("error decoding entries: \(error)")
                completion(self.subcategoryNames, error)
            }
            }.resume()
    }
    
    func fetchSubcategoryDetails(_ subcategory: Subcategory, completion: @escaping CompletionHandler = { _ in }) {
        
        // Match rawValues to JSON
        let underscoredTempCategory = tempCategorySelection.replacingOccurrences(of: " ", with: "_").lowercased()
        let underscoredSubcategory = subcategory.rawValue.replacingOccurrences(of: " ", with: "_").lowercased()
        let requestURL = NetworkController.baseURL
            .appendingPathComponent(underscoredTempCategory)
            .appendingPathComponent(underscoredSubcategory)
            .appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { ( data, _, error) in
            if let error = error {
                NSLog("error fetching tasks: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("no data returned from dtat task.")
                completion(NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let decodedResponse = try jsonDecoder.decode([IndividualResource].self, from: data)
                self.subcategoryDetails = decodedResponse
                completion(nil)
            } catch {
                completion(error)
            }
        }.resume()
    }
    
    // Determine which subcategory will be a parameter in the detail fetch
    func determineSubcategoryDetailFetch() {
        if subcategoryNames.contains(tempSubcategorySelection) {
            subcategoryAtIndexPath = Subcategory.init(rawValue: tempSubcategorySelection) ?? Subcategory.all
        } else {
            NSLog("Error finding matching subcategory")
        }
    }

    // MARK: - Search Fetch
    static func fetchAllForSearch(completion: @escaping CompletionHandler = { _ in }) {
        
        let requestURL = NetworkController.baseURL
            .appendingPathExtension("json")
        
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
                self.allEducationObjects = decodedResponse.education.all
                self.allLegalAdminObjects = decodedResponse.legalAdministrative.all
                self.allHealthCareObjects = decodedResponse.healthCare.all
                self.allFoodObjects = decodedResponse.food.all
                self.allHygieneObjects = decodedResponse.hygiene.all
                self.allOutreachServicesObjects = decodedResponse.outreachServices._all
                
                for eachObject in self.allShelterObjects {
                    self.filteredObjects.append(eachObject)
                }
                
                for eachObject in self.allEducationObjects {
                    self.filteredObjects.append(eachObject)
                }
                
                for eachObject in self.allLegalAdminObjects {
                    self.filteredObjects.append(eachObject)
                }
                
                for eachObject in self.allHealthCareObjects {
                    self.filteredObjects.append(eachObject)
                }
                
                for eachObject in self.allFoodObjects {
                    self.filteredObjects.append(eachObject)
                }
                
                for eachObject in self.allHygieneObjects {
                    self.filteredObjects.append(eachObject)
                }
                
                for eachObject in self.allOutreachServicesObjects {
                    self.filteredObjects.append(eachObject)
                }
                
                completion(nil)
                
            } catch {
                NSLog("Error decoding FirebaseObject: \(error)")
                completion(error)
            }
        }.resume()
    }
    
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
}
