//
//  extensions.swift
//  Boast
//
//  Created by David Keimig on 9/13/20.
//

import Foundation

extension TimeInterval {

    func stringFromTimeInterval() -> String {
        let time = NSInteger(self)

        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        if hours > 0 {
            if hours >= 24 {
                let days = (hours / 24)
                if (days == 1) {
                    return String(format: "%0.1d day ago", days)
                }
                return String(format: "%0.1d days ago", days)
            }
            return String(format: "%0.2d hours ago", hours)
        }
        else if minutes > 0 {
            if (minutes == 1) {
                return String(format: "%0.1d minute ago", minutes)
            }
            return String(format: "%0.2d minutes ago", minutes)
        }
        else if seconds > 0 {
            if (seconds == 1) {
                return String(format: "%0.1d second ago", seconds)
            }
            return String(format: "%0.2d seconds ago", seconds)
        }

        return "moments ago"
    }
    
}
