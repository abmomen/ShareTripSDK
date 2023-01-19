//
//  Helpers.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/23/22.
//

import SwiftyJSON

public class Helpers {
    public class func generateHtml(content: String,
                                   style: String = "body {text-align: justify; margin: 6px 12px 6px 12px;}") -> String {
        
        let htmlStr = """
            <DOCTYPE HTML>
                <html lang='en'>
                    <head>
                        <meta charset='UTF-8'>
                        <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>
                        <style> \(style) </style>
                    </head>
                    <body> \(content) </body>
                </html>
        """
        return htmlStr
    }
    
    public class func generateHtml(content: String, header: String) -> String {
        let contentStr = """
            <h2>\(header)</h2>
            \(content)
            """
        return Helpers.generateHtml(content: contentStr)
    }
    
    public class func closedRange(startingValue: Int, length: Int) -> ClosedRange<Int> {
        if (startingValue + length - 1) < startingValue {
            return startingValue...startingValue
        }
        return startingValue...(startingValue + length - 1)
    }
    
    public static func convertToArrayOfDictionary(text: String) -> Any? {
        
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [])
            } catch {
                STLog.info(error.localizedDescription)
            }
        }
        
        return nil
        
    }
    
    public static func decoder(jwtToken jwt: String) -> [String: Any] {
        let segments = jwt.components(separatedBy: ".")
        return decodeJWTPart(segments[1]) ?? [:]
    }
    
    public static func decodeJWTPart(_ value: String) -> [String: Any]? {
        guard let bodyData = base64UrlDecode(value),
              let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
            return nil
        }
        
        return payload
    }
    
    public static func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 = base64 + padding
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
    
    public static func loadJSON(jsonFileName name: String) -> Data? {
        if let path = Bundle.main.path(forResource: name, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
                
            } catch {
                STLog.info("error")
            }
        }
        return nil
    }
    
    public static func convertJsonToString(json: JSON) -> String {
        do {
            let rawData = try json.rawData()
            let convertedString = String(data: rawData, encoding: String.Encoding.utf8)
            return convertedString ?? ""
        } catch {
            STLog.info("Error \(error)")
        }
        return ""
        
    }
    
}

public class Utility {
    public static let months = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    public class func componentFromDate(date: Date) -> DateComponents {
        return Calendar(identifier: .gregorian).dateComponents([.year, .month, .day, .weekday, .hour, .minute, .second], from: date)
    }
}

