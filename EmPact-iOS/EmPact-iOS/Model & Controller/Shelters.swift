//
//  Shelters.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/1/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

struct Shelters: Decodable {

    var all: [IndividualResource]
    var men: [IndividualResource]
    var women: [IndividualResource]
    var youth: [IndividualResource]
    
    var shelterDictionary: [String: [IndividualResource]] {
        return ["all": all,
                "men": men,
                "women": women,
                "youth": youth]
    }
    var dictionary: NSDictionary {
        return shelterDictionary as NSDictionary
    }

}

