//
//  Healthcare.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 4/1/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

struct Healthcare: Decodable {
    
    var all: [HealthcareIndividualResource]
    var clinics: [HealthcareIndividualResource]
    var emergency: [HealthcareIndividualResource]
    var hiv: [HealthcareIndividualResource]
    var mentalHealth: [HealthcareIndividualResource] // mental-health
    var rehab: [HealthcareIndividualResource]
    var women: [HealthcareIndividualResource]
    
    var shelterDictionary: [String: [HealthcareIndividualResource]] {
        return ["all": all,
                "clinics": clinics,
                "emergency": emergency,
                "hiv": hiv,
                "mentalHealth": mentalHealth,
                "rehab": rehab,
                "women": women]
    }
    var dictionary: NSDictionary {
        return shelterDictionary as NSDictionary
    }
    
}

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
