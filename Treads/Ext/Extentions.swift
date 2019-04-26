//
//  Extentions.swift
//  Treads
//
//  Created by Denis Rakitin on 2019-04-22.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import Foundation

extension Double {
    func metersToMiles (places: Int)-> Double {
        let divisor = pow(10.0, Double(places))
        return((self / 1000) * divisor).rounded() / divisor
    }
}


extension Int {
    func formatTimeDurationToString() -> String {
        let durationHours = self/3600
    
        let durartionMinutes = (self % 3600) / 60
        let durationSeconds = (self % 3600) % 60
      
        if durationSeconds < 0 {
            return "00:00:00"
        } else {
            if durationHours == 0 {
                return String(format: "%02d:%02d", durartionMinutes, durationSeconds)
            } else {
                return String(format: "%02d:%02d:%02d", durationHours, durartionMinutes, durationSeconds)
            }
        }
    }
}

extension NSDate {
    func getDateString() -> String {
        let calendar = Calendar.current
        let month =  calendar.component(.month, from: self as Date)
        let day = calendar.component(.day, from: self as Date)
        let year = calendar.component(.year, from: self as Date)
        return "\(day)/\(month)/\(year)"
    }
}
