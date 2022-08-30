//
//  Extension+Date.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 24.08.2022.
//

import Foundation

extension Date {
    func dateToString(_ dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
//"d MMM yyyy HH:mm"
