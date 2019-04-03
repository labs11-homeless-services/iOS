//
//  NetworkController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/28/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class NetworkController {
    
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
    func fetchSubcategoryNames(_ subcategory: String, completion: @escaping CompletionHandler = { _ in }) {
        
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
                print("Network decodedResponse: \(decodedResponse)")
                
                let subcategories = decodedResponse
                //let capitalizedCategories = categories.map {$0.capitalized}
                
                //self.subcategoryNames = capitalizedCategories
                print("Network Categories: \(subcategories)")
                completion(nil)
            } catch {
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
    
    
    
    
    
    func fetchCategoriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        
        let requestURL = NetworkController.baseURL.appendingPathExtension("json")
        
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
            
            // Make JSON Decoder
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                //let decodedResponse = try JSONDecoder().decode([String: Categories].self, from: data)
                let decodedResponse = try jsonDecoder.decode(FirebaseObject.self, from: data)
                print("Network decodedResponse: \(decodedResponse)")
                let categories = decodedResponse
                //let categories = Array(decodedResponse.values)
                print("Network Categories: \(categories)")
                completion(nil)
            } catch {
                print("error decoding entries: \(error)")
                completion(error)
            }
            
        }.resume()
    }
}
