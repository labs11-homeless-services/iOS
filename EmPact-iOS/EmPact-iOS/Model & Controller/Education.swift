//
//  Education.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/1/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

struct Education: Decodable {
    
    enum EducationKeys: String, CodingKey {
        
        case address
        case city
        case name
        case state
        case latitude
        case longitude
        case phone
        case postalCode = "postal code"
    }
    
    var address: String
    var city: String
    var name: String
    var state: String
    
    var latitude: String?
    var longitude: String?
    var phone: String?
    var postalCode: String? // "postal code"
    
    init(from decoder: Decoder) throws {
        
        // Container representing top level of info
        // Education resources are inside an array, so need a keyed container
        let container = try decoder.container(keyedBy: EducationKeys.self)
        
        // Not nested inside anything
        address = try container.decode(String.self, forKey: .address)
        city = try container.decode(String.self, forKey: .city)
        name = try container.decode(String.self, forKey: .name)
        state = try container.decode(String.self, forKey: .state)
        latitude = try container.decode(String.self, forKey: .latitude)
        longitude = try container.decode(String.self, forKey: .longitude)
        phone = try container.decode(String.self, forKey: .phone)
        postalCode = try container.decode(String.self, forKey: .postalCode)
        
    }
    
}
