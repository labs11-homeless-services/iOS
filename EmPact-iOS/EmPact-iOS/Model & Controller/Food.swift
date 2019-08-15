//
//  Food.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 4/1/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

struct Food: Decodable {
    
    var all: [IndividualResource]
    var foodPantries: [IndividualResource]
    var foodStamps: [IndividualResource]
    
    var foodDictionary: [String: [IndividualResource]] {
        return ["all": all,
                "food pantries": foodPantries,
                "food stamps": foodStamps]
    }
    var dictionary: NSDictionary {
        return foodDictionary as NSDictionary
    }
}
