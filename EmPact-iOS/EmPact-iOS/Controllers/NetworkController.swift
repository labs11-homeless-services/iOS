//
//  NetworkController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/28/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class NetworkController {
    
    var tempCategorySelection = ""
    var subcategoryName = ""
    
    var categoryNames: [String] = []
    var subcategoryNames: [String] = []
    
    var tempCategoryDictionary: [String: [Any]] = [:]
    var subcategoryDetails: [ShelterIndividualResource] = []
       
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

        let requestURL = NetworkController.baseURL
            .appendingPathComponent("\(category.rawValue)")
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
                case .healthcare:
                    let decodedResponse = try jsonDecoder.decode(Healthcare.self, from: data)
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
        
        //guard var tempSubcategory = Subcategory(rawValue: subcategory) else { return }
        determineSubcategory(subcategory: subcategory)
        
        let requestURL = NetworkController.baseURL
            .appendingPathComponent(tempCategorySelection.lowercased())
            .appendingPathComponent(subcategory.rawValue)
            .appendingPathExtension("json")
        
        print("subcategory requestURL: \(requestURL)")
        
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
                //let decodedResponse = try jsonDecoder.decode(tempDecodedCategory.self, from: data)
                //self.subcategoryDetails = decodedResponse.men
                
//                let decodedResponse = try jsonDecoder.decode(Shelters.self, from: data)
//                self.subcategoryDetails = decodedResponse.men
                
                print("Network Categories: \(self.subcategoryDetails)")
                
                completion(nil)
            } catch {
                completion(error)
            }
        }.resume()
    }

    func determineSubcategory(subcategory: Subcategory) {
        
        var temp = subcategory
        switch subcategory {
        case .all:
            temp = Subcategory.all
        case .women:
            temp = Subcategory.women
        case .men:
            temp = Subcategory.men
        case .youth:
            temp = Subcategory.youth
        case .ged:
            temp = Subcategory.ged
        case .publicComputers:
            temp = Subcategory.publicComputers
        case .foodPantries:
            temp = Subcategory.foodPantries
        case .foodStamps:
            temp = Subcategory.foodStamps
        case .clinics:
            temp = Subcategory.clinics
        case .emergency:
            temp = Subcategory.emergency
        case .hiv:
            temp = Subcategory.hiv
        case .mentalHealth:
            temp = Subcategory.mentalHealth
        case .rehab:
            temp = Subcategory.rehab
        case .bathrooms:
            temp = Subcategory.bathrooms
        case .showers:
            temp = Subcategory.showers
        case .benefits:
            temp = Subcategory.benefits
        case .afterSchool:
            temp = Subcategory.afterSchool
        case .domesticViolence:
            temp = Subcategory.domesticViolence
        case .socialServices:
            temp = Subcategory.socialServices
        }
    }
    
}
