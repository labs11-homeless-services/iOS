//
//  FirebaseObject.swift
//  EmPact-iOS
//
//  Created by Jonah Bergevin on 4/11/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

struct FirebaseObject: Decodable {
    
    var education: Education
    var legalAdministrative: LegalAdministrative
    var food: Food
    var healthCare: HealthCare
    var hygiene: Hygiene
    var outreachServices: OutreachServices
    var shelters: Shelters
    var jobs: Jobs
}
