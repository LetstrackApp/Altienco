//
//  String+Extension.swift
//  Altienco
//
//  Created by mac on 20/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//

import Foundation

extension String {
//1
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        //2022-09-06T05:06:26.000Z
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current

        return dateFormatter.date(from: self)
    }
//3
    func convertToDisplayFormat() -> String {
        guard let date = self.convertToDate() else { return "N/A" }
        return date.convertToMonthYearFormat()
    }
    func dateFormat() -> String {
        guard let date = self.self.convertGiftCardFormat() else { return "N/A" }
        return date.dayOfWeek()
    }
    func dayFormat() -> String {
        guard let date = self.self.convertGiftCardFormat() else { return "N/A" }
        return date.dateOfMonth()
    }
    func timeFormat() -> String {
        guard let date = self.self.convertGiftCardFormat() else { return "N/A" }
        return date.toTime()
    }
    
    func convertGiftCardFormat() -> Date? {
        let dateFormatter = DateFormatter()
        //2022-09-06T05:06:26.000Z
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current

        return dateFormatter.date(from: self)
    }
//3
    func giftCardFormat() -> String {
        guard let date = self.convertGiftCardFormat() else { return "N/A" }
        return date.convertToMonthYearFormat()
    }
}
