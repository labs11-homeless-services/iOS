//
//  IndividualResource.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 4/3/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

struct IndividualResource: Decodable {
    var address: String
    var city: String
    var keywords: String
    var name: String
    var state: String
    
    var latitude: String?
    var longitude: String?
    var phone: Int?
    var postalCode: String?
    
//    private enum CodingKeys: String, CodingKey {
//        case address
//        case city
//        case keywords
//        case name
//        case state
//        case latitude
//        case longitude
//        case phone
//        case postalCode = "postal code"
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        address = try container.decode(String.self, forKey: .address)
//        city = try container.decode(String.self, forKey: .city)
//        keywords = try container.decode(String.self, forKey: .keywords)
//        name = try container.decode(String.self, forKey: .name)
//        state = try container.decode(String.self, forKey: .state)
//        latitude = try container.decode(String.self, forKey: .latitude)
//        longitude = try container.decode(String.self, forKey: .longitude)
//
//        if let phoneValue = try? container.decode(Int.self, forKey: .phone) {
//            phone = String(phoneValue)
//        } else {
//            phone = try container.decode(String.self, forKey: .phone)
//        }
//    }
}
