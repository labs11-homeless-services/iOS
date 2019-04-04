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
    
    var categoryNames: [String] = []

    var subcategoryNames: [String] = []
    var subcategoryName = "shelters"
    
    var subcategoryDetails: [IndividualResource] = []
       
    typealias CompletionHandler = (Error?) -> Void
    static var baseURL: URL!  { return URL(string: "https://empact-e511a.firebaseio.com/") }
    
    
    // CATEGORY NAMES
    func fetchCategoryNames(completion: @escaping CompletionHandler = { _ in }) {
        
        let requestURL = NetworkController.baseURL
            .appendingPathComponent("categories")
            .appendingPathExtension("json")
        
        print("requestURL: \(requestURL)")
        
        URLSession.shared.dataTask(with: requestURL) { ( data, _, error) in
            if let error = error {
                print("error fetching tasks: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("no data returned from data task.")
                completion(NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let decodedResponse = try jsonDecoder.decode(Categories.self, from: data)
                print("Network decodedResponse: \(decodedResponse)")
                
                let categories = decodedResponse.categoryName
                let capitalizedCategories = categories.map {$0.capitalized}
                
                self.categoryNames = capitalizedCategories
                print("Network Categories: \(categories)")
                completion(nil)
            } catch {
                completion(error)
            }
        }.resume()
    }
    

    
    // SUBCATEGORY NAMES
    func fetchSubcategoriesNames(_ subcategory: SubCategory, completion: @escaping CompletionHandler = { _ in }) {

        let requestURL = NetworkController.baseURL
            .appendingPathComponent("\(subcategory.rawValue)")
            .appendingPathExtension("json")
        print("\(subcategory) url: \(requestURL)")
        
        URLSession.shared.dataTask(with: requestURL) { ( data, _, error) in
            if let error = error {
                print("error fetching tasks: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("no data returned from data task.")
                completion(NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                
                switch subcategory {
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
                        //print(decodedResponseDictionary.key)
                        self.subcategoryNames.append("\(decodedResponseDictionary.key)")
                    }
                    print(self.subcategoryNames)
                case .jobs:
                    let decodedResponse = try jsonDecoder.decode(Jobs.self, from: data)
                    for decodedResponseDictionary in decodedResponse.dictionary {
                        self.subcategoryNames.append("\(decodedResponseDictionary.key)")
                    }
                }
                
                //print("Network Categories: \(String(describing: self.subcategoryNames))")
                completion(nil)
            } catch {
                print("error decoding entries: \(error)")
                completion(error)
            }
            
        }.resume()
    }
    
    // SUBCATEGORY LIST RESULTS DETAILS
    func fetchSubcategoryDetails(_ subcategory: String, completion: @escaping CompletionHandler = { _ in }) {
        
        let requestURL = NetworkController.baseURL
            .appendingPathComponent(subcategoryName)
            .appendingPathExtension("json")
        
        print("requestURL: \(requestURL)")
        
        URLSession.shared.dataTask(with: requestURL) { ( data, _, error) in
            if let error = error {
                print("error fetching tasks: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("no data returned from dtat task.")
                completion(NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let decodedResponse = try jsonDecoder.decode(Shelters.self, from: data)
                
                self.subcategoryDetails = decodedResponse.women
                print("Network Categories: \(self.subcategoryDetails)")
                
                completion(nil)
            } catch {
                completion(error)
            }
        }.resume()
    }
}
