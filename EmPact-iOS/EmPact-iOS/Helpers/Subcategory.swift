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
    case legal = "legal administrative"
    case food
    case healthCare = "health care"
    case outreach = "outreach services"
    case hygiene
    case shelters
    case jobs
}

enum UnderscoredCategory: String, Decodable {
    case legal = "legal administrative"
    case healthCare = "health care"
    case outreach = "outreach services"
}

enum Subcategory: String, Decodable {
    case all
    case women
    case men
    case youth
    case ged
    case publicComputers = "public computers"
    case foodPantries = "food pantries"
    case foodStamps = "food stamps"
    case clinics
    case emergency
    case hiv
    case mentalHealth = "mental health"
    case rehab
    case bathrooms
    case showers
    case benefits
    case afterSchool = "after school"
    case domesticViolence = "domestic violence"
    case socialServices = "social services"
}




