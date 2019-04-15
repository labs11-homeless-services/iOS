//
//  FirebaseObject.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/11/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

struct FirebaseObject: Decodable {
    
    var education: Education
    var legalAdministrative: LegalAdministrative // emergency_services
    var food: Food
    //var healthcare: Healthcare
    var hygiene: Hygiene
    var outreachServices: OutreachServices // outreach_services
    var shelters: Shelters
    var jobs: Jobs
    
}
