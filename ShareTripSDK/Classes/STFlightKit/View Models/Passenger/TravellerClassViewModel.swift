//
//  TravellerClassViewModel.swift
//  STFlightKit
//
//  Created by ST-iOS on 11/23/22.
//



public extension TravellerClassViewModel {
    enum Rows {
        case traveller(TravellerType)
        case childrenAge
        case flightClass(FlightClass)
    }
}

public extension TravellerClassViewModel {
    class Callback {
        public var didChangeAdultCount: () -> Void = { }
        public var didChangeChildCount: () -> Void = { }
        public var didFailValidation: (String) -> Void = { _ in }
        public var didPassValidation: () -> Void = { }
    }
}

public class TravellerClassViewModel {
    public var travelDate: Date?
    public let callback = Callback()
    private let maxTraveler: Int = 7
    
    public private(set) var adultCount = 1
    public private(set) var infantCount = 0
    public private(set) var sections = [[Rows]]()
    public private(set) var childrenAges = [Int : Date?]()
    public private(set) var flightClass: FlightClass = .economy
    
    public private(set) var childCount = 0 {
        didSet {
            updateChildAges()
            setupRows()
        }
    }
    
    public var totalTravelersCount: Int {
        return adultCount + childCount + infantCount
    }
    
    public init() { setupRows() }
    
    private func setupRows() {
        sections.removeAll()
        var travellerRows = [Rows]()
        var flightClassRows = [Rows]()
        for travellerType in TravellerType.allCases {
            travellerRows.append(.traveller(travellerType))
        }
        sections.append(travellerRows)
        
        sections.append(.init(repeating: .childrenAge, count: childCount))
        
        for flightClass in FlightClass.allCases {
            flightClassRows.append(.flightClass(flightClass))
        }
                
        sections.append(flightClassRows)
    }
    
    public func validateInputs() {
        if adultCount + childCount > maxTraveler {
            callback.didFailValidation("Adult and child count surpass the allowed traveller count")
            return
        }
        
        if infantCount > adultCount {
            callback.didFailValidation("Infant count cannot exed adult traveller count")
            return
        }
        
        for index in 0..<childCount {
            if childrenAges[index] == nil {
                callback.didFailValidation("Please select child \(index + 1) date of birth")
                return
            }
        }
        callback.didPassValidation()
    }
    
    public func getChidrenAgeStrings() -> [String] {
        var agesInString = [String]()
        
        childrenAges.forEach { (key, value) in
            let dateString = value?.toString(format: .isoDate)
            agesInString.append(dateString ?? "")
        }
        
        return agesInString
    }
    
    public func updateTravellerCount(_ count: Int, for traveller: TravellerType) {
        switch traveller {
        case .adult:
            if (count + childCount) <= maxTraveler {
                adultCount = count
                callback.didChangeAdultCount()
            }
            
            //infactCount is bound to be equal to adultCount
            if adultCount <= infantCount {
                infantCount = adultCount
            }
            
        case .child:
            if (adultCount + count) <= maxTraveler {
                childCount = count
                callback.didChangeChildCount()
            }
            
        case .infant:
            if count <= adultCount {
                infantCount = count
            }
        }
    }
    
    public func getMaxNumber(for traveller: TravellerType) -> Int {
        switch traveller {
        case .adult:
            return maxTraveler - childCount
        case .child:
            return maxTraveler - adultCount
        case .infant:
            return adultCount
        }
    }
    
    public func getMinNumber(for traveller: TravellerType) -> Int {
        switch traveller {
        case .adult:
            return 1
        case .child, .infant:
            return 0
        }
    }

    public func setChildAge(at index: Int, _ ageYear: Date?) {
        childrenAges[index] = ageYear
    }
    
    private func updateChildAges() {
        var updatedAges = [Int : Date?]()
        for index in 0..<childCount {
            updatedAges[index] = childrenAges[index]
        }
        childrenAges = updatedAges
    }
    
    private let calendar = Calendar(identifier: .gregorian)
    private var components = DateComponents()
    
    private var minAgeOfChild: Date? {
        components.calendar = calendar
        components.year = -12
        return calendar.date(byAdding: components, to: travelDate ?? Date())
    }
    
    private var maxAgeOfChild: Date? {
        components.calendar = calendar
        components.year = -2
        return calendar.date(byAdding: components, to: travelDate ?? Date())
    }
    
    public func getDateSelectionCellViewModel(for indexPath: IndexPath) -> ConfigurableTableViewCellData {
        var text = ""
        let placeholder = maxAgeOfChild?.toString(format: .custom(Constants.App.dateFormat)) ?? ""
        let imageIcon = "calander-mono"
        let title = "Child \(indexPath.row + 1) date or birth"
        
        if let childDateOfBirth = childrenAges[indexPath.row] {
            text = childDateOfBirth?.toString(format: .custom(Constants.App.dateFormat)) ?? ""
        }
        
        return SDDateSelectionCellViewModel(
            title: title, text: text,
            placeholder: placeholder,
            imageString: imageIcon,
            minDate: minAgeOfChild,
            maxDate: maxAgeOfChild
        )
    }
    
    public func setFlightClass(_ selectedClass: FlightClass) {
        flightClass = selectedClass
    }
    
    public func travellerCount(for travellerType: TravellerType) -> Int {
        switch travellerType {
        case .adult:
            return adultCount
        case .child:
            return childCount
        case .infant:
            return infantCount
        }
    }
    
    public func getTravelerNumber(for traveler: TravellerType) -> Int {
        switch traveler {
        case .adult:
            return adultCount
        case .child:
            return childCount
        case .infant:
            return infantCount
        }
    }
}
