//
//  Categories.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/28/19.
//  Copyright © 2019 EmPact. All rights reserved.
//
// Pokemon, SWAPI, Codable Week, Song - Weezer Album, Codable on Pokemon & SWAPI, Make a file for each Model by name

import Foundation

struct Categories: Decodable {
    
//    enum CategoriesKeys: String, CodingKey {
//        case education
//        case emergencyServices = "emergency_services"
//        case food
//        case healthcare
//        case hygiene
//        case outreachServices = "outreach_services"
//        case shelters
//    }
    
    var education: [Education]
//    var emergencyServices: [EmergencyServices] // emergency_services
//    var food: [Food]
//    var healthcare: [Healthcare]
//    var hygiene: [Hygiene]
//    var outreachServices: [OutreachServices] // outreach_services
//    var shelters: [Shelters]

//    init(from decoder: Decoder) throws {
//        
//        // Get a container that represents the top level of information
//        // The top level is a dictionary, so use a keyed container
//        let container = try decoder.container(keyedBy: CategoriesKeys.self)
//        
//        // education is an array of the Education struct
//        education = try container.decode([Education].self, forKey: .education)
//        
//        emergencyServices = try container.decode([EmergencyServices].self, forKey: .emergencyServices)
//        food = try container.decode([Food].self, forKey: .food)
//        healthcare = try container.decode([Healthcare].self, forKey: .healthcare)
//        hygiene = try container.decode([Hygiene].self, forKey: .hygiene)
//        outreachServices = try container.decode([OutreachServices].self, forKey: .outreachServices)
//        shelters = try container.decode([Shelters].self, forKey: .shelters)
//        
//    }
    
}


struct SingleResource {
    let singleResourceId: String
    
}
