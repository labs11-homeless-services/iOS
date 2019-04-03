//
//  Hygiene.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/1/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

struct Hygiene: Decodable {
    
    var all: [IndividualResource]
    var bathrooms: [IndividualResource]
    var showers: [IndividualResource]

    var hygieneDictionary: [String: [IndividualResource]] {
        return ["all": all,
                "bathrooms": bathrooms,
                "showers": showers]
    }
    var dictionary: NSDictionary {
        return hygieneDictionary as NSDictionary
    }
    
}
