//
//  AppVersion.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/29/22.
//

import Foundation

public class AppVersion: Codable {
    public let iOS: VersionData?
}

public class VersionData: Codable {
    public let version: String?
    public let isForceUpdate: Bool?
}
