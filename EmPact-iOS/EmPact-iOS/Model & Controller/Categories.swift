//
//  Categories.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/28/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

struct Category: Decodable { // Not Categories as the top level but education and decode for that.
    
    let education: Education
    let shelters: Shelters
    let outreachServices: OutreachServices
    let hygiene: Hygiene
    let emergencyServices: EmergencyServices
    let food: Food
    let healthcare: Healthcare
    
}



struct SingleResource {
    let singleResourceId: String
    
}
