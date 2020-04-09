//
//  Education.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 4/1/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

struct Education: Decodable {
  
    var all: [IndividualResource]
    var ged: [IndividualResource]
    var publicComputers: [IndividualResource]
    
    var educationDictionary: [String: [IndividualResource]] {
        return ["all": all,
                "ged": ged,
                "public computers": publicComputers]
    }
    var dictionary: NSDictionary {
        return educationDictionary as NSDictionary
    }
}
