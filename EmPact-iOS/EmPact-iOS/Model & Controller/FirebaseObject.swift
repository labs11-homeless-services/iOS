//
//  Categories.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/28/19.
//  Copyright © 2019 EmPact. All rights reserved.
//
// Pokemon, SWAPI, Codable Week, Song - Weezer Album, Codable on Pokemon & SWAPI, Make a file for each Model by name

import Foundation

struct FirebaseObject: Decodable {
        
    var education: [Education]
    var emergencyServices: [EmergencyServices] // emergency_services
    var food: [Food]
    var healthcare: [Healthcare]
    var hygiene: [Hygiene]
    var outreachServices: [OutreachServices] // outreach_services
    var shelters: [Shelters]
    
}

