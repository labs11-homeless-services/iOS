//
//  NetworkController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/28/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class NetworkController {
    
    var tempSubcategorySelection = ""
    var subcategoryAtIndexPath: Subcategory!
    
    var tempCategorySelection = ""
    var subcategoryName = ""
    
    var categoryNames: [String] = []
    var subcategoryNames: [String] = []
    
    var tempCategoryDictionary: [String: [Any]] = [:]
    var tempSimpleDictionary: [String: Any] = [:]
    
    var shelterSubcategoryDetails: [ShelterIndividualResource] = []
    var subcategoryDetails: [IndividualResource] = []
       
    typealias CompletionHandler = (Error?) -> Void
    typealias Handler = ([String], Error?) -> Void
    static var baseURL: URL!  { return URL(string: "https://empact-e511a.firebaseio.com/") }
    
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
    
    // SUBCATEGORY NAMES
    func fetchSubcategoriesNames(_ category: Category, completion: @escaping Handler = { _, _ in }) {

        //var baseURL: URL!  { return URL(string: "https://empact-e511a.firebaseio.com/outreach_services") }
        
        let requestURL = NetworkController.baseURL
            .appendingPathComponent("\(category.rawValue)")
            .appendingPathExtension("json")
        
        print("requestURL: \(requestURL)")
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
                case .education:
                    let decodedResponse = try jsonDecoder.decode(Education.self, from: data)
                    for decodedResponseDictionary in decodedResponse.dictionary {
                        self.subcategoryNames.append("\(decodedResponseDictionary.key)")
                    }
                case .legal:
                    let decodedResponse = try jsonDecoder.decode(LegalAdministrative.self, from: data)
                    for decodedResponseDictionary in decodedResponse.dictionary {
                        self.subcategoryNames.append("\(decodedResponseDictionary.key)")
                    }
                case .food:
                    let decodedResponse = try jsonDecoder.decode(Food.self, from: data)
                    for decodedResponseDictionary in decodedResponse.dictionary {
                        self.subcategoryNames.append("\(decodedResponseDictionary.key)")
                    }
                case .healthcare:
                    let decodedResponse = try jsonDecoder.decode(Healthcare.self, from: data)
                    for decodedResponseDictionary in decodedResponse.dictionary {
                        self.subcategoryNames.append("\(decodedResponseDictionary.key)")
                    }
                case .outreach:
                    let decodedResponse = try jsonDecoder.decode(OutreachServices.self, from: data)
                    for decodedResponseDictionary in decodedResponse.dictionary {
                        self.subcategoryNames.append("\(decodedResponseDictionary.key)")
                    }
                case .hygiene:
                    let decodedResponse = try jsonDecoder.decode(Hygiene.self, from: data)
                    for decodedResponseDictionary in decodedResponse.dictionary {
                        self.subcategoryNames.append("\(decodedResponseDictionary.key)")
                    }
                case .shelters:
                    let decodedResponse = try jsonDecoder.decode(Shelters.self, from: data)
                    for decodedResponseDictionary in decodedResponse.dictionary {
                        self.subcategoryNames.append("\(decodedResponseDictionary.key)")
                    }
                case .jobs:
                    let decodedResponse = try jsonDecoder.decode(Jobs.self, from: data)
                    for decodedResponseDictionary in decodedResponse.dictionary {
                        self.subcategoryNames.append("\(decodedResponseDictionary.key)")
                    }
                    print("tempCategoryDictionary: \(self.tempCategoryDictionary)")
                }
                
                completion(self.subcategoryNames, nil)
            } catch {
                NSLog("error decoding entries: \(error)")
                completion(self.subcategoryNames, error)
            }
            
        }.resume()
    }
    
    func determineSubcategoryFetch(completion: @escaping CompletionHandler = { _ in }) {
        
        if tempCategorySelection == "Shelters" {
            fetchSubcategoriesNames(Category.shelters)
        } else if tempCategorySelection == "Health Care" {
            fetchSubcategoriesNames(Category.healthcare)
        } else if tempCategorySelection == "Food" {
            fetchSubcategoriesNames(Category.food)
        } else if tempCategorySelection == "Hygiene" {
            fetchSubcategoriesNames(Category.hygiene)
        } else if tempCategorySelection == "Outreach Services" {
            fetchSubcategoriesNames(Category.outreach)
        } else if tempCategorySelection == "Education" {
            fetchSubcategoriesNames(Category.education)
        } else if tempCategorySelection == "Legal Administrative" {
            fetchSubcategoriesNames(Category.legal)
        } else if tempCategorySelection == "Jobs" {
            fetchSubcategoriesNames(Category.jobs)
        }
    }
    
    // SUBCATEGORY LIST RESULTS DETAILS
    func fetchSubcategoryDetails(_ subcategory: Subcategory, completion: @escaping CompletionHandler = { _ in }) {
        
        //var baseURL: URL!  { return URL(string: "https://empact-e511a.firebaseio.com/outreach_services") }
        //guard var tempSubcategory = Subcategory(rawValue: subcategory) else { return }
        
        let requestURL = NetworkController.baseURL
            .appendingPathComponent(tempCategorySelection.lowercased())
            // Construct a string and remove the underscore "_"
            .appendingPathComponent(subcategory.rawValue)
            .appendingPathExtension("json")
        
        print("requestURL: \(requestURL)")
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
            //jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                
                if subcategory.rawValue == "shelters" {
                    let decodedResponse = try jsonDecoder.decode([ShelterIndividualResource].self, from: data)
                    self.shelterSubcategoryDetails = decodedResponse
                    print("shelter decodedResponse: \(self.shelterSubcategoryDetails)")
                } else {//
                //    if subcategory.rawValue == Category.education.rawValue ||
//                    subcategory.rawValue == Category.legal.rawValue ||
//                    subcategory.rawValue == Category.food.rawValue ||
//                    subcategory.rawValue == Category.healthcare.rawValue ||
//                    subcategory.rawValue == Category.outreach.rawValue ||
//                    subcategory.rawValue == Category.hygiene.rawValue ||
//                    subcategory.rawValue == Category.jobs.rawValue {
        
                    let decodedResponse = try jsonDecoder.decode([IndividualResource].self, from: data)
                    self.subcategoryDetails = decodedResponse
                    print("pre fetch decodedResponse: \(self.subcategoryDetails)")
                }
                
                
                print("Subcategory Details: \(self.subcategoryDetails)")
                
                completion(nil)
            } catch {
                completion(error)
            }
        }.resume()
    }
    
    func determineSubcategoryDetailFetch() {
        
        if Subcategory.all.rawValue == tempSubcategorySelection {
            subcategoryAtIndexPath = Subcategory.all
        } else if tempSubcategorySelection == Subcategory.women.rawValue {
            subcategoryAtIndexPath = Subcategory.women
        } else if Subcategory.men.rawValue == tempSubcategorySelection {
            subcategoryAtIndexPath = Subcategory.men
        } else if Subcategory.youth.rawValue == tempSubcategorySelection {
            subcategoryAtIndexPath = Subcategory.youth
        } else if Subcategory.ged.rawValue == tempSubcategorySelection {
            subcategoryAtIndexPath = Subcategory.ged
        } else if Subcategory.publicComputers.rawValue == tempSubcategorySelection {
            subcategoryAtIndexPath = Subcategory.publicComputers
        } else if Subcategory.foodPantries.rawValue == tempSubcategorySelection {
            subcategoryAtIndexPath = Subcategory.foodPantries
        } else if Subcategory.foodStamps.rawValue == tempSubcategorySelection {
            subcategoryAtIndexPath = Subcategory.foodStamps
        } else if Subcategory.clinics.rawValue == tempSubcategorySelection {
            subcategoryAtIndexPath = Subcategory.clinics
        } else if Subcategory.emergency.rawValue == tempSubcategorySelection {
            subcategoryAtIndexPath = Subcategory.emergency
        } else if Subcategory.hiv.rawValue == tempSubcategorySelection {
            subcategoryAtIndexPath = Subcategory.hiv
        } else if Subcategory.mentalHealth.rawValue == tempSubcategorySelection {
            subcategoryAtIndexPath = Subcategory.mentalHealth
        } else if Subcategory.rehab.rawValue == tempSubcategorySelection {
            subcategoryAtIndexPath = Subcategory.rehab
        } else if Subcategory.bathrooms.rawValue == tempSubcategorySelection {
            subcategoryAtIndexPath = Subcategory.bathrooms
        } else if Subcategory.showers.rawValue == tempSubcategorySelection {
            subcategoryAtIndexPath = Subcategory.showers
        } else if Subcategory.benefits.rawValue == tempSubcategorySelection {
            subcategoryAtIndexPath = Subcategory.benefits
        } else if Subcategory.afterSchool.rawValue == tempSubcategorySelection {
            subcategoryAtIndexPath = Subcategory.afterSchool
        } else if Subcategory.domesticViolence.rawValue == tempSubcategorySelection {
            subcategoryAtIndexPath = Subcategory.domesticViolence
        } else if Subcategory.socialServices.rawValue == tempSubcategorySelection {
            subcategoryAtIndexPath = Subcategory.socialServices
        }
    }
    
    static func fetchAllForSearch(completion: @escaping CompletionHandler = { _ in }) {
        
        let requestURL = NetworkController.baseURL
            .appendingPathExtension("json")
        print(requestURL)
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
                let decodedResponse = try jsonDecoder.decode(AllCategories.self, from: data)
                print(decodedResponse)
                
                completion(nil)
            } catch {
                completion(error)
            }
            }.resume()
    }

}
