//
//  Subcategory.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/3/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

enum Category: String, Decodable {
    case education
    case legal = "legal_administrative"
    case food
    case healthcare = "health_care"
    case outreach = "outreach_services"
    case hygiene
    case shelters
    case jobs
}

enum Subcategory: String, Decodable {
    case all
    case women
    case men
    case youth
    case ged
    case publicComputers = "public_computers"
    case foodPantries = "food_pantries"
    case foodStamps = "food_stamps"
    case clinics
    case emergency
    case hiv
    case mentalHealth = "mental_health"
    case rehab
    case bathrooms
    case showers
    case benefits
    case afterSchool = "after_school"
    case domesticViolence = "domestic_violence"
    case socialServices = "social_services"
}



