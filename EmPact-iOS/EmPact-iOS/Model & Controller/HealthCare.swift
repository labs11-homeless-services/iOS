//
//  Healthcare.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 4/1/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

struct HealthCare: Decodable {
    
    var all: [IndividualResource]
    var clinics: [IndividualResource]
    var emergency: [IndividualResource]
    var hiv: [IndividualResource]
    var mentalHealth: [IndividualResource]
    var rehab: [IndividualResource]
    var women: [IndividualResource]
    
    var healthcareDictionary: [String: [IndividualResource]] {
        return ["all": all,
                "clinics": clinics,
                "emergency": emergency,
                "hiv": hiv,
                "mental health": mentalHealth,
                "rehab": rehab,
                "women": women]
    }
    var dictionary: NSDictionary {
        return healthcareDictionary as NSDictionary
    }
}
