//
//  EmergencyServices.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 4/1/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

struct LegalAdministrative: Decodable {
    
    var all: [IndividualResource]
    var benefits: [IndividualResource]
    
    var legalAdministrativeDictionary: [String: [IndividualResource]] {
        return ["all": all,
                "benefits": benefits]
    }
    var dictionary: NSDictionary {
        return legalAdministrativeDictionary as NSDictionary
    }
    
}
