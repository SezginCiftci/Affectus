//
//  AddNewEntity.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 27.07.2022.
//

import Foundation

struct AddNewEntity {
    var id: UUID?
    var moodDate: Date?
    var notesText: String?
    var moodEmoji: Int?
    var moodDescribe: String?
    var activitySelection: String?
}

struct AddNewEntityList {
    var idArray = [UUID]()
    var moodDateArray = [Date]()
    var notesTextArray = [String]()
    var moodEmojiArray = [Int]()
    var moodDescribeArray = [String]()
    var activitySelectionArray = [String]()
}

