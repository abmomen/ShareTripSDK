//
//  UserDefaults+Key.swift
//  ShareTrip
//
//  Created by Mehedi Hasan on 27/4/20.
//  Copyright © 2020 ShareTrip. All rights reserved.
//

import Foundation

public extension UserDefaults {
    enum Key: String {
        case reviewWorthyActionCount
        case lastReviewRequestAppVersion
        case reviewRequestShownCount
        case reviewRequestFirstShown
    }
    
    func integer(forKey key: Key) -> Int {
        return integer(forKey: key.rawValue)
    }
    
    func string(forKey key: Key) -> String? {
        return string(forKey: key.rawValue)
    }
    
    func date(forKey key: Key) -> Date? {
        return object(forKey: key.rawValue) as? Date
    }
    
    func set(_ integer: Int, forKey key: Key) {
        set(integer, forKey: key.rawValue)
    }
    
    func set(_ object: Any?, forKey key: Key) {
        set(object, forKey: key.rawValue)
    }
}
