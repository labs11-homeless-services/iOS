//
//  Shelters.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/1/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

struct Shelters: Codable {

    var all: [ShelterIndividualResource]
    var men: [ShelterIndividualResource]
    var women: [ShelterIndividualResource]
    var youth: [ShelterIndividualResource]
    
    var shelterDictionary: [String: [ShelterIndividualResource]] {
        return ["all": all,
                "men": men,
                "women": women,
                "youth": youth]
    }
    var dictionary: NSDictionary {
        return shelterDictionary as NSDictionary
    }
}


