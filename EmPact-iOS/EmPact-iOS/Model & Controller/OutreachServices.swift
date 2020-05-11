//
//  OutreachServices.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 4/3/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

struct OutreachServices: Decodable {
 
    var _all: [IndividualResource]
    var afterSchool: [IndividualResource]
    var domesticViolence: [IndividualResource]
    var socialServices: [IndividualResource]
    
    var outreachDictionary: [String: [IndividualResource]] {
        return ["all": _all,
                "after school": afterSchool,
                "domestic violence": domesticViolence,
                "social services": socialServices]
    }
    var dictionary: NSDictionary {
        return outreachDictionary as NSDictionary
    }
}
