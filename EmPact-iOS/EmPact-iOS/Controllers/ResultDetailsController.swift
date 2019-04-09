//
//  ResultDetailsController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 4/9/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

class ResultDetailsController {
    
    var tempCategorySelection = ""
    
    typealias CompletionHandler = (Error?) -> Void
    static var baseURL: URL!  { return URL(string: "https://empact-e511a.firebaseio.com/") }
    
//    // SUBCATEGORY LIST RESULTS DETAILS
//    func fetchSubcategoryDetails(_ subcategory: Subcategory, completion: @escaping CompletionHandler = { _ in }) {
//        
//        //guard var tempSubcategory = Subcategory(rawValue: subcategory) else { return }
//        
//        let requestURL = NetworkController.baseURL
//            .appendingPathComponent(tempCategorySelection.lowercased())
//            .appendingPathComponent(subcategory.rawValue)
//            .appendingPathExtension("json")
//        
//        print("subcategory requestURL: \(requestURL)")
//        
//        URLSession.shared.dataTask(with: requestURL) { ( data, _, error) in
//            if let error = error {
//                NSLog("error fetching tasks: \(error)")
//                completion(error)
//                return
//            }
//            
//            guard let data = data else {
//                NSLog("no data returned from dtat task.")
//                completion(NSError())
//                return
//            }
//            
//            let jsonDecoder = JSONDecoder()
//            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
//            
//            do {
//                //let decodedResponse = try jsonDecoder.decode(tempDecodedCategory.self, from: data)
//                //self.subcategoryDetails = decodedResponse.men
//                
//                //                let decodedResponse = try jsonDecoder.decode(Shelters.self, from: data)
//                //                self.subcategoryDetails = decodedResponse.men
//                
//                print("Network Categories: \(self.subcategoryDetails)")
//                
//                completion(nil)
//            } catch {
//                completion(error)
//            }
//        }.resume()
//    }
    
}
