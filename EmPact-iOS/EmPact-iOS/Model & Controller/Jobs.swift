//
//  Jobs.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/3/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

struct Jobs: Decodable {
    
    var all: [IndividualResource]
    
    var jobsDictionary: [String: [IndividualResource]] {
        return ["all": all]
    }
    var dictionary: NSDictionary {
        return jobsDictionary as NSDictionary
    }
    
}
