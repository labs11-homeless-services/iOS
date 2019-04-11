//
//  Healthcare.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 4/1/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

struct Healthcare: Decodable {
    
    var all: [IndividualResource]
    var clinics: [IndividualResource]
    var emergency: [IndividualResource]
    var hiv: [IndividualResource]
    var mentalHealth: [IndividualResource] // mental-health
    var rehab: [IndividualResource]
    var women: [IndividualResource]
    
    var healthcareDictionary: [String: [IndividualResource]] {
        return ["all": all,
                "clinics": clinics,
                "emergency": emergency,
                "hiv": hiv,
                "mentalHealth": mentalHealth,
                "rehab": rehab,
                "women": women]
    }
    var dictionary: NSDictionary {
        return healthcareDictionary as NSDictionary
    }
}
// Testing to see if we still need this. 
struct HealthcareIndividualResource: Decodable {

    var address: String
    var city: String
    var name: String
    var state: String

    var latitude: String?
    var longitude: String?
    var phone: String?
    var postalCode: String? // "postal code"
    var details: String?
    var keywords: String?
    var services: String?
    var subcategory: String?

}
