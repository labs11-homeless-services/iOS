//
//  OutreachServices.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/1/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

struct OutreachServices: Decodable {
    var afterSchool: [IndividualResource] // after-school
    var domesticViolence: [IndividualResource] // domestic-violence
    var socialServices: [IndividualResource] // social-services
    
    var outreachDictionary: [String: [IndividualResource]] {
        return ["afterSchool": afterSchool,
                "domesticViolence": domesticViolence,
                "socialServices": socialServices]
    }
    var dictionary: NSDictionary {
        return outreachDictionary as NSDictionary
    }

}


