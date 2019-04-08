//
//  IndividualShelter.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/5/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

struct IndividualShelter: Decodable {
    var address: String
    var city: String
    var details: [String]
    var hours: String
    var keywords: String
    
    var latitude: String?
    var longitude: String?
    
    var name: String
    var phone: Int?
    var postalCode: String?
    var services: [String]
    var state: String
    
    enum ShelterKeys: String, CodingKey {
        
    }
}
