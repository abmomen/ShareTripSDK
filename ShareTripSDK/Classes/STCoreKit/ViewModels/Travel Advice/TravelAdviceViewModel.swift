//
//  TravelAdviceViewModel.swift
//  ShareTrip
//
//  Created by Sharetrip-iOS on 11/11/2020.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

public class TravelAdviceViewModel {

    public private(set) var isLoading = Observable<Bool>(false)
    private let service = TravelAdviceService()
    var travelAdviceData: TravelAdviceSearch?
    typealias CompletionCallBack = (_ success: Bool, _ error: String?) -> Void

    let restrictionsDic : [String: String] =
        [
            "restrictionsOnInternalMovement" : "Restrictions On Internal Movement",
            "cancelPublicEvents" : "Cancel Public Events",
            "restrictionsOnGatherings" : "Restrictions On Gatherings",
            "closePublicTransport" : "Close Public Transport",
            "workplaceClosing" : "Workplace Closing",
            "stayAtHomeRequirements" : "Stay At Home Requirements",
            "schoolClosing" : "School Closing",
            "internationalTravelControls" : "International Travel Controls",
            "testingPolicy" : "Testing Policy",
            "contactTracing" : "Contact Tracing"
        ]


    //MARK: - Utils
    func getDestinationDetailsData() -> DestinationDetailsModel {
        let destinationDetailsData = DestinationDetailsModel(
            countryName: travelAdviceData?.trips?.first?.covid19Stats?.country ?? "",
            time: travelAdviceData?.trips?.first?.covid19Stats?.date ?? "",
            riskLevel: travelAdviceData?.riskLevel ?? "green",
            countryRestriction: generateRestrictionString(),
            requirements: Requirement(quarentine: travelAdviceData?.requirements?.quarantine ?? "", test: travelAdviceData?.requirements?.tests ?? "", mask: travelAdviceData?.requirements?.masks ?? ""),
            countryRecommandation: travelAdviceData?.recommendation ?? "No requirements found",
            advice:  String(travelAdviceData?.trips?.first?.advice?.levelDesc?.dropFirst(9) ?? ""),

            newCases: travelAdviceData?.trips?.first?.covid19Stats?.newCases ?? 0,
            newDeath: travelAdviceData?.trips?.first?.covid19Stats?.newDeaths ?? 0,
            totalCases: travelAdviceData?.trips?.first?.covid19Stats?.totalCases ?? 0,
            totalDeath: travelAdviceData?.trips?.first?.covid19Stats?.totalDeaths ?? 0)
        
        return destinationDetailsData
    }

    private func generateRestrictionString() -> String {
        let restrictionsData =  travelAdviceData?.trips?.first?.advice?.restrictions
        guard let restrictions = restrictionsData else {return ""}

        var restrictionString = ""
        let mirror = Mirror(reflecting: restrictions)
        let lastChildObj = mirror.children.count - 1

        for (index, attr) in mirror.children.enumerated() {

            guard let attKey = attr.label, let attributeValue =  attr.value as? RestrictionsOnGatheringsClass else  {return ""}

            let attributeStr = attributeValue.levelDesc
            if attributeStr != nil {
                if index == lastChildObj {
                    let attString = "• " + getRestrictionsName(with: attKey) + ":" + attributeStr!.dropFirst(8) + "."
                    restrictionString =   restrictionString + attString
                } else {
                    let attString = "• " + getRestrictionsName(with: attKey) + ":" + attributeStr!.dropFirst(8) + "." + "\n" + "\n"
                    restrictionString =   restrictionString + attString
                }
            }
        }
        if restrictionString == "" {
            return "No Restrictions Found"
        }
        return restrictionString
    }

    private func getRestrictionsName(with restrictionsValue: String) -> String {
        for (key, value) in restrictionsDic {
            if key == restrictionsValue {
                return value
            }
        }
        return ""
    }

    //MARK: - API Calls
    func loadTravelAdviceData(withCountryCode: String, onCompletion: @escaping CompletionCallBack) {
        guard !isLoading.value else { return }
        isLoading.value = true
        service.getTravelAdvice(countryCode: withCountryCode, onSuccess: { [weak self] travelAdviceInfo in
            if self?.travelAdviceData != nil { self?.travelAdviceData = nil}
            if let travelAdviceData = travelAdviceInfo {
                self?.travelAdviceData = travelAdviceData
                onCompletion(true, nil)
            } else {
                onCompletion(false, nil)
            }
            self?.isLoading.value = false
        }, onFailure: { [weak self] error in
            if self?.travelAdviceData != nil { self?.travelAdviceData = nil}
            onCompletion(false, error)
            self?.isLoading.value = false
        })
    }

}
