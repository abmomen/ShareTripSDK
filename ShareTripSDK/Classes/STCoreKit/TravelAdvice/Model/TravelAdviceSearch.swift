//
//  TravelAdviceSearch.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 11/11/2020.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import Foundation

// MARK: - TravelAdviceSearch
struct TravelAdviceSearch: Codable {
    let userID, riskLevel, startDate, recommendation: String?
    let requirements: Requirements?
    let trips: [Trip]?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case userID = "UserID"
        case riskLevel = "risk_level"
        case startDate = "start_date"
        case recommendation, requirements, trips, name
    }
}

// MARK: - Requirements
struct Requirements: Codable {
    let tests, quarantine, masks: String?
}

// MARK: - Trip
struct Trip: Codable {
    let from: String?
    let advice: Advice?
    let startDate: String?
    let covid19Stats: Covid19Stats?
    let data: DataClass?
    let toAirport, fromAirport, to: String?

    enum CodingKeys: String, CodingKey {
        case from, advice
        case startDate = "start_date"
        case covid19Stats = "covid19_stats"
        case data
        case toAirport = "to_airport"
        case fromAirport = "from_airport"
        case to
    }
}

// MARK: - Advice
struct Advice: Codable {
    let restrictions: Restrictions?
    let lon, containmentAndHealthIndex, stringencyIndex, lat: String?
    let date: String?
    let level: Int?
    let governmentResponseIndex, economicSupportIndex, recommendation: String?
    let countryCode: String?
    let levelDesc: String?
    let requirements: Requirements?

    enum CodingKeys: String, CodingKey {
        case restrictions, lon
        case containmentAndHealthIndex = "containment_and_health_index"
        case stringencyIndex = "stringency_index"
        case lat, date, level
        case governmentResponseIndex = "government_response_index"
        case economicSupportIndex = "economic_support_index"
        case recommendation
        case countryCode = "country_code"
        case levelDesc = "level_desc"
        case requirements
    }
}

// MARK: - Restrictions
struct Restrictions: Codable {
    let restrictionsOnInternalMovement, cancelPublicEvents, restrictionsOnGatherings, closePublicTransport: RestrictionsOnGatheringsClass?
    let workplaceClosing, stayAtHomeRequirements, schoolClosing, internationalTravelControls: RestrictionsOnGatheringsClass?
    let testingPolicy, contactTracing: RestrictionsOnGatheringsClass?

    enum CodingKeys: String, CodingKey {
        case restrictionsOnInternalMovement = "restrictions_on_internal_movement"
        case cancelPublicEvents = "cancel_public_events"
        case restrictionsOnGatherings = "restrictions_on_gatherings"
        case closePublicTransport = "close_public_transport"
        case workplaceClosing = "workplace_closing"
        case stayAtHomeRequirements = "stay_at_home_requirements"
        case schoolClosing = "school_closing"
        case internationalTravelControls = "international_travel_controls"
        case testingPolicy = "testing_policy"
        case contactTracing = "contact_tracing"
    }
}

// MARK: - RestrictionsOnGatheringsClass
struct RestrictionsOnGatheringsClass: Codable {
    let level: Int?
    let levelDesc: String?

    enum CodingKeys: String, CodingKey {
        case level
        case levelDesc = "level_desc"
    }
}

// MARK: - Covid19Stats
struct Covid19Stats: Codable {
    let continent: String?
    let totalDeathsPerMillion, medianAge, lifeExpectancy, newDeathsPerMillion: Double?
    let cvdDeathRate: Int?
    let country, lon: String?
    let aged65_Older, diabetesPrevalence, handwashingFacilities: Double?
    let totalCases: Int?
    let hospitalBedsPerThousand: Double?
    let totalDeaths: Int?
    let id: String?
    let date: String?
    let populationDensity, newCasesPerMillion, totalCasesPerMillion: Double?
    let newDeaths: Int?
    let countryISO: String?
    let population: Int?
    let aged70_Older: Double?
    let lat: String?
    let gdpPerCapita: Double?
    let newCases: Int?

    enum CodingKeys: String, CodingKey {
        case continent
        case totalDeathsPerMillion = "total_deaths_per_million"
        case medianAge = "median_age"
        case lifeExpectancy = "life_expectancy"
        case newDeathsPerMillion = "new_deaths_per_million"
        case cvdDeathRate = "cvd_death_rate"
        case country, lon
        case aged65_Older = "aged_65_older"
        case diabetesPrevalence = "diabetes_prevalence"
        case handwashingFacilities = "handwashing_facilities"
        case totalCases = "total_cases"
        case hospitalBedsPerThousand = "hospital_beds_per_thousand"
        case totalDeaths = "total_deaths"
        case id, date
        case populationDensity = "population_density"
        case newCasesPerMillion = "new_cases_per_million"
        case totalCasesPerMillion = "total_cases_per_million"
        case newDeaths = "new_deaths"
        case countryISO = "country_iso"
        case population
        case aged70_Older = "aged_70_older"
        case lat
        case gdpPerCapita = "gdp_per_capita"
        case newCases = "new_cases"
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let economic: Economic?
    let containmentAndClosure: ContainmentAndClosure?
    let healthSystems: HealthSystems?

    enum CodingKeys: String, CodingKey {
        case economic
        case containmentAndClosure = "containment_and_closure"
        case healthSystems = "health_systems"
    }
}

// MARK: - ContainmentAndClosure
struct ContainmentAndClosure: Codable {
    let cancelPublicEvents: DebtContractReliefClass?
    let restrictionsOnGatherings: RestrictionsOnGatherings?
    let restrictionsOnInternalMovement, closePublicTransport, schoolClosing, workplaceClosing: DebtContractReliefClass?
    let stayAtHomeRequirements: RestrictionsOnGatherings?
    let internationalTravelControls: DebtContractReliefClass?

    enum CodingKeys: String, CodingKey {
        case cancelPublicEvents = "cancel_public_events"
        case restrictionsOnGatherings = "restrictions_on_gatherings"
        case restrictionsOnInternalMovement = "restrictions_on_internal_movement"
        case closePublicTransport = "close_public_transport"
        case schoolClosing = "school_closing"
        case workplaceClosing = "workplace_closing"
        case stayAtHomeRequirements = "stay_at_home_requirements"
        case internationalTravelControls = "international_travel_controls"
    }
}

// MARK: - DebtContractReliefClass
struct DebtContractReliefClass: Codable {
    let level: Int?
    let notes: [Note]?
    let levelDesc: String?

    enum CodingKeys: String, CodingKey {
        case level, notes
        case levelDesc = "level_desc"
    }
}

// MARK: - Note
struct Note: Codable {
    let countryCode: String?
    let date: String?
    let type: String?
    let note: String?
    let sources: [String]?

    enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
        case date, type, note, sources
    }
}

// MARK: - RestrictionsOnGatherings
struct RestrictionsOnGatherings: Codable {
    let level: Int?
}

// MARK: - Economic
struct Economic: Codable {
    let debtContractRelief, fiscalMeasures, internationalSupport: DebtContractReliefClass?
    let incomeSupport: IncomeSupport?

    enum CodingKeys: String, CodingKey {
        case debtContractRelief = "debt_contract_relief"
        case fiscalMeasures = "fiscal_measures"
        case internationalSupport = "international_support"
        case incomeSupport = "income_support"
    }
}

// MARK: - IncomeSupport
struct IncomeSupport: Codable {
    let notes: [Note]?
    let levelDesc: String?

    enum CodingKeys: String, CodingKey {
        case notes
        case levelDesc = "level_desc"
    }
}

// MARK: - HealthSystems
struct HealthSystems: Codable {
    let publicInformationCampaigns, emergencyInvestmentInHealthcare, testingPolicy: DebtContractReliefClass?
    let investmentInVaccines: RestrictionsOnGatherings?
    let contactTracing: DebtContractReliefClass?

    enum CodingKeys: String, CodingKey {
        case publicInformationCampaigns = "public_information_campaigns"
        case emergencyInvestmentInHealthcare = "emergency_investment_in_healthcare"
        case testingPolicy = "testing_policy"
        case investmentInVaccines = "investment_in_vaccines"
        case contactTracing = "contact_tracing"
    }
}


