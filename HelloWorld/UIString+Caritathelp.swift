//
//  UIString+Caritathelp.swift
//  Caritathelp
//
//  Created by Jeremy gros on 05/01/2017.
//  Copyright © 2017 Jeremy gros. All rights reserved.
//

import Foundation

extension String {
    func transformToDate() -> String {
        guard self != nil else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let target = String(describing: self)
        let range = target.index(target.startIndex, offsetBy: 10)
        let dateOk = target.substring(to: range)
        
        let date = dateFormatter.date(from: dateOk)
        dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale!
        dateFormatter.dateStyle = DateFormatter.Style.full
        print("date : \(date) ++ \(self)")
        let datefinale = dateFormatter.string(from: date!)
        return datefinale
    }
    
    func getHeureFromString() -> String {
        guard self != nil else {
            return ""
        }
        let start = self.index(self.startIndex, offsetBy: 11)
        let end = self.index(self.endIndex, offsetBy: -10)
        let Range = start..<end
        let heure = self.substring(with: Range)

        return heure
    }
}
