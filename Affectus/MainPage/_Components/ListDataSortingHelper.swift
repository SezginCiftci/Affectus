//
//  ListDataSortingHelper.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 3.09.2022.
//

import Foundation

class ListDataSortingHelper {
    
    static var shared = ListDataSortingHelper()
    
    var entityListData: AddNewEntityList?
    var resultArray = [AddNewEntity]()
    
    
    func setDataWithDate(at itemIndex: Int) {
        
        
        var myDate: Date = .now
        var myText = ""
        var myEmoji = 0
        var myDescription = ""
        var myActivity = ""
        var myId = UUID()
        
        for (index, dates) in (entityListData?.moodDateArray ?? []).enumerated() where index == itemIndex {
            myDate = dates
            break
        }
        
        for (index, texts) in (entityListData?.notesTextArray ?? []).enumerated() where index == itemIndex {
            myText = texts
            break
        }
        
        for (index, emojis) in (entityListData?.moodEmojiArray ?? []).enumerated() where index == itemIndex {
            myEmoji = emojis
            break
        }
        
        for (index, describes) in (entityListData?.moodDescribeArray ?? []).enumerated() where index == itemIndex {
            myDescription = describes
            break
        }
        
        for (index, activities) in (entityListData?.activitySelectionArray ?? []).enumerated() where index == itemIndex {
            myActivity = activities
            break
        }
        
        for (index, id) in (entityListData?.idArray ?? []).enumerated() where index == itemIndex {
            myId = id
            break
        }
        
        resultArray.append(AddNewEntity(id: myId, moodDate: myDate, notesText: myText, moodEmoji: myEmoji, moodDescribe: myDescription, activitySelection: myActivity))
        
    }
    
    func sortDataWithDate(completion: (_ sortedArray: [AddNewEntity]) -> ()) {
        
        let sortedArr = resultArray.sorted { data1, data2 in
            if let dateFirst = data1.moodDate, let dateSecond = data2.moodDate {
                return dateFirst.timeIntervalSinceNow < dateSecond.timeIntervalSinceNow
            }
            return false
        }
        
        completion(sortedArr)
    }
}
