//
//  ScheduleFilterCellData.swift
//  STCoreKit
//
//  Created by ST-iOS on 11/23/22.
//

public struct ScheduleFilterCellData {
    public let title: String
    public let titleImage: String
    public var selected: Bool
    
    public init(title: String, titleImage: String, selected: Bool) {
        self.title = title
        self.titleImage = titleImage
        self.selected = selected
    }
}

