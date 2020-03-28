//
//  IconImageHelper.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/2/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

enum CategoryIconImages: String {
    case shelter = "C-Shelters"
    case education = "C-Education"
    case food = "C-Food"
    case healthcare = "C-Healthcare"
    case hygiene = "C-Hygiene"
    case outreach = "C-Outreachservices"
    case legal = "C-Legal"
    case jobs = "C-Jobs"
}

extension CategoryIconImages {
    static let allItems: [CategoryIconImages] = [.shelter,
                                        .education,
                                        .food,
                                        .healthcare,
                                        .hygiene,
                                        .outreach,
                                        .legal,
                                        .jobs]
}

enum SubcategoryIconImages: String, CaseIterable {
    case all = "S-all"
    case women = "S-women"
    case men = "S-men"
    case youth = "S-youth"
    case ged = "S-GED"
    case publicComputers = "S-computers"
    case foodPantries = "S-foodPantries"
    case foodStamps = "S-foodStamps"
    case clinics = "S-clinic"
    case emergency = "S-emergency"
    case hiv = "S-hiv"
    case mentalHealth = "S-mentalHealth"
    case rehab = "S-rehab"
    case bathrooms = "S-bathroom"
    case showers = "S-showers"
    case benefits = "S-benefits"
    case afterSchool = "S-afterSchool"
    case domesticViolence = "S-abuse"
    case socialServices = "S-socialService"
}

extension SubcategoryIconImages {
    static let allItems: [SubcategoryIconImages] = [.all,
                                        .women,
                                        .men,
                                        .youth,
                                        .ged,
                                        .publicComputers,
                                        .foodPantries,
                                        .foodStamps,
                                        .clinics,
                                        .emergency,
                                        .hiv,
                                        .mentalHealth,
                                        .rehab,
                                        .bathrooms,
                                        .showers,
                                        .benefits,
                                        .afterSchool,
                                        .domesticViolence,
                                        .socialServices]
}
