//
//  IndividualResource.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/8/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation



struct IndividualResource: Decodable {
    
    var address: String?
    var city: String
    var details: Any?
    var hours: String?
    
    var keywords: String
    var latitude: String?
    var longitude: String?
    
    var name: String
    var phone: Any
    var postalCode: String?
    var state: String
    
    var services: Any?
    
    enum IndividualResourceCodingKeys: String, CodingKey {
        case address
        case city
        case details
        case hours
        case keywords
        case latitude
        case longitude
        case name
        case phone
        case postalCode = "postal code"
        case state
        case services
        
    }
    
    
    init(from decoder: Decoder) throws {
        
        // Container representing top level of information, which is a dictionary
        let container = try decoder.container(keyedBy: IndividualResourceCodingKeys.self)
        
        address = try container.decodeIfPresent(String.self, forKey: .address)
        city = try container.decode(String.self, forKey: .city)
        
        do {
            // Try to decode the value as an array
            details = try container.decodeIfPresent([String].self, forKey: .details)
        } catch {
            // If that doesn't work, try to decode as a single value
            details = try container.decodeIfPresent(String.self, forKey: .details)
        }
        
        hours = try container.decodeIfPresent(String.self, forKey: .hours)
        
        keywords = try container.decode(String.self, forKey: .keywords)
        latitude = try container.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try container.decodeIfPresent(String.self, forKey: .longitude)
        
        name = try container.decode(String.self, forKey: .name)
        
        do {
            phone = try container.decodeIfPresent(String.self, forKey: .phone)
        } catch {
            phone = try container.decodeIfPresent(Int.self, forKey: .phone)
        }
    
        postalCode = try container.decodeIfPresent(String.self, forKey: .postalCode)
        state = try container.decode(String.self, forKey: .state)
        
        do {
            services = try container.decodeIfPresent([String].self, forKey: .services)
        } catch {
            services = try container.decodeIfPresent(String.self, forKey: .services)
        }
        
    }
}

struct IndividualResourceTopLevel: Decodable {
    
    var JSON: [IndividualResource]
}




// Education & Jobs - latitude/longitude is decodeIfPresent
// Education - no "postal code" - decodeIfPresent
// Education - Index 31 doesn't have a "phone key"
// Take out all the arrays in details/services and make them strings
// Hygiene has no "details" or "services"
// Hygiene has no "address"
// Hygiene has phone numbers as both ints and strings
// No fetches for underscored Subcategories
