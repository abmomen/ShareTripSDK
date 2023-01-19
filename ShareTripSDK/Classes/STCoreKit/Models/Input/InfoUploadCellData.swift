//
//  InfoUploadCellData.swift
//  STCoreKit
//
//  Created by ST-iOS on 12/1/22.
//

public struct InfoUploadCellData: ConfigurableTableViewCellData {
    public let hasPassportCopy: Bool
    public let hasVisaCopy: Bool
    public let passportHidden: Bool
    public let visaHidden: Bool
    
    public init(hasPassportCopy: Bool, hasVisaCopy: Bool, passportHidden: Bool, visaHidden: Bool) {
        self.hasPassportCopy = hasPassportCopy
        self.hasVisaCopy = hasVisaCopy
        self.passportHidden = passportHidden
        self.visaHidden = visaHidden
    }
    
    public init(hasPassportCopy: Bool, hasVisaCopy: Bool) {
        self.hasPassportCopy = hasPassportCopy
        self.hasVisaCopy = hasVisaCopy
        self.passportHidden = false
        self.visaHidden = false
    }
    
    public init(hasPassportCopy: Bool, hasVisaCopy: Bool, passportHidden: Bool) {
        self.hasPassportCopy = hasPassportCopy
        self.hasVisaCopy = hasVisaCopy
        self.passportHidden = passportHidden
        self.visaHidden = false
    }
    
    public init(hasPassportCopy: Bool, hasVisaCopy: Bool, visaHidden: Bool) {
        self.hasPassportCopy = hasPassportCopy
        self.hasVisaCopy = hasVisaCopy
        self.passportHidden = false
        self.visaHidden = visaHidden
    }
}
