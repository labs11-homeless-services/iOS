//
//  NetworkController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/28/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class NetworkController {
    
    static var categoryNames: [String] = []
    
    typealias CompletionHandler = (Error?) -> Void
    static var baseURL: URL!  { return URL(string: "https://empact-e511a.firebaseio.com/") }
    
    static func fetchCategoriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        
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
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let decodedResponse = try jsonDecoder.decode(Categories.self, from: data)
                print("Network decodedResponse: \(decodedResponse)")
                let categories = decodedResponse
                print("Network Categories: \(categories)")
                completion(nil)
            } catch {
                print("error decoding entries: \(error)")
                completion(error)
            }
        }.resume()
    }
    
    static func fetchCategoriesNames(completion: @escaping CompletionHandler = { _ in }) {
        
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
                print("no data returned from dtat task.")
                completion(NSError())
                return
            }
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let decodedResponse = try jsonDecoder.decode(Categories.self, from: data)
                print("Network decodedResponse: \(decodedResponse)")
                let categories = decodedResponse.categoryName
                self.categoryNames = categories
                print("Network Categories: \(categories)")
                completion(nil)
            } catch {
                print("error decoding entries: \(error)")
                completion(error)
            }
            }.resume()
    }
    
}
