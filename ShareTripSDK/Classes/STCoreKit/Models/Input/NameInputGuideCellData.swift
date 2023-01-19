//
//  NameInputGuideCellData.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/1/22.
//

public struct NameInputGuideCellData: ConfigurableTableViewCellData {
    public let instructions: String
    
    public init(instructions: String) {
        self.instructions = instructions
    }
    
    public static var flightInstruction: NameInputGuideCellData {
        let instruction = "For booking Saudia Airlines (SV) flights, Passenger’s with single name has to insert  Passenger’s Father’s name as in passport in the GIVEN Name Field, as per Saudia(SV) airlines guideline."
        
        return NameInputGuideCellData(instructions: instruction)
    }
}
