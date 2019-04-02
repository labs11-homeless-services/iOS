//
//  Categories.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 4/2/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

struct Categories: Codable {
    
    var categoryName: [String]
    
//    enum categoryNameKeys: String, CodingKey {
//        case categoryName = "category_name"
////        case shelters
////        case healthCare = "health_care"
////        case food
////        case hygiene
////        case outreachServices = "outreach_services"
////        case education
////        case legalAdministrative = "legal_administrative"
////        case jobs
//    }
    
//    init(from decoder: Decoder) throws {
//       let container = try decoder.container(keyedBy: categoryNameKeys.self)
//
//        categoryName = try container.decode([String].self, forKey: .categoryName)
////
////            // Not nested inside anything
////            shelters = try container.decode(String.self, forKey: .shelters)
////            city = try container.decode(String.self, forKey: .city)
////            name = try container.decode(String.self, forKey: .name)
////            state = try container.decode(String.self, forKey: .state)
////            latitude = try container.decode(String.self, forKey: .latitude)
////            longitude = try container.decode(String.self, forKey: .longitude)
////            phone = try container.decode(String.self, forKey: .phone)
////            postalCode = try container.decode(String.self, forKey: .postalCode)
//    }
    
}

struct CategoriesEspanol: Codable {
    
    var categoryName: [String]
}
