//
//  StringExtension.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/20/22.
//

import Foundation

public extension String {
    var localizedString: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func trim(newLine: Bool = false) -> String {
        var trimmedStr = ""
        if newLine {
            trimmedStr = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        } else {
            trimmedStr = self.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        trimmedStr = trimmedStr.replacingOccurrences(of: "\'", with: "")
        return trimmedStr
    }
    
    func getPlural(_ yes: Bool) -> String {
        return yes ? self+"s": self
    }
    
    func getPlural(count: Int) -> String {
        return count > 1 ? self+"s": self
    }
    
    func validateEmailStandard() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    func validateForEmail() -> Result<Void, AppError> {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let valid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
        
        if valid {
            return .success(())
        } else {
            return .failure(.validationError("Please type a valid email address"))
        }
    }
    
    func validateForName(nameType: String = "Given Name") -> Result<Void, AppError> {
        guard self.count > 1 else {
            return .failure(.validationError("Please type meaningful \(nameType)"))
        }
        for chr in self {
            if !(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") && chr != " " {
                return .failure(.validationError("\(nameType.capitalized) can't contain any special charachter"))
            }
        }
        return .success(())
    }
    
    func validateForMobileNumber() -> Result<Void, AppError> {
        guard self.count > 10 else {
            return .failure(.validationError("Please type a valid phone number"))
        }
        guard !self.contains("+") else {
            return .failure(.validationError("Do not put special charachter (+) in mobile number"))
        }
        return .success(())
    }
    
    func validateEmailBetter() -> Bool {
        let firstpart = "[A-Z0-9a-z._%+-]{3,30}"
        let serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let emailRegex = firstpart + "@" + serverpart + "[A-Za-z]{2,8}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailPredicate.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let regx = "(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).*"
        return  NSPredicate(format: "SELF MATCHES %@", regx).evaluate(with: self)
    }
    
    /**
     Swift extension method to check for a valid email address (uses Apples data detector instead of a regex)
     */
    func isValidEmail() -> Bool {
        
        guard !self.lowercased().hasPrefix("mailto:") else { return false }
        guard let emailDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else { return false }
        let matches = emailDetector.matches(in: self, options: NSRegularExpression.MatchingOptions.anchored, range: NSRange(location: 0, length: self.count))
        guard matches.count == 1 else { return false }
        return matches[0].url?.scheme == "mailto"
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

public extension Data {
    func toString() -> String? {
        return String(data: self, encoding: .utf8)
    }
}

public extension String {
    var isReallyEmpty: Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var boolValue: Bool {
        return self.lowercased() == "yes" || self == "1" || self.lowercased() == "true"
    }
    
    func toDate() -> Date? {
        for format in DateFormatType.allCases {
            if let date = Date(fromString: self, format: format) {
                return date
            }
        }
        return nil
    }
    
    func containsWhitespaceAndNewlines() -> Bool {
        return rangeOfCharacter(from: .whitespacesAndNewlines) != nil
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func isValidPhoneNumber() -> Bool {
        let regEx = "^(?:\\+?88)?01[13-9][0-9]{8}$"
        let phoneNumberCheck = NSPredicate(format: "SELF MATCHES[c]%@", regEx)
        return phoneNumberCheck.evaluate(with: self)
    }
    
    func isValidNumeric() -> Bool {
        let regEx = "^[0-9]*$"
        let numericCheck = NSPredicate(format: "SELF MATCHES[c]%@", regEx)
        return numericCheck.evaluate(with: self)
    }
    
    func isValidAlphaNumeric() -> Bool {
        let regEx = "^[a-zA-Z0-9]+$"
        let alphaNumericCheck = NSPredicate(format: "SELF MATCHES[c]%@", regEx)
        return alphaNumericCheck.evaluate(with: self)
    }
    
    func isValidAlpha() -> Bool {
        let regEx = "^[a-zA-Z]+$"
        let alphaCheck = NSPredicate(format: "SELF MATCHES[c]%@", regEx)
        return alphaCheck.evaluate(with: self)
    }
    
    func strikeThrough() -> NSAttributedString {
        let mutableString =  NSMutableAttributedString(string: self)
        mutableString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, mutableString.length))
        return mutableString
    }
}
