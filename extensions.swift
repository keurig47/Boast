//
//  extensions.swift
//  Boast
//
//  Created by David Keimig on 9/13/20.
//

import Foundation
import SwiftUI

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
                    return "\(days) day ago"
                }
                return "\(days) days ago"
            }
            return "\(hours) hours ago"
        }
        else if minutes > 0 {
            if (minutes == 1) {
                return "\(minutes) minute ago"
            }
            return "\(minutes) minutes ago"
        }
        else if seconds > 0 {
            if (seconds == 1) {
                return "\(seconds) second ago"
            }
            return "\(seconds) seconds ago"
        }

        return "moments ago"
    }
    
}

extension Binding {
    /// Execute block when value is changed.
    ///
    /// Example:
    ///
    ///     Slider(value: $amount.didSet { print($0) }, in: 0...10)
    func didSet(execute: @escaping (Value) ->Void) -> Binding {
        return Binding(
            get: {
                return self.wrappedValue
            },
            set: {
                self.wrappedValue = $0
                execute($0)
            }
        )
    }
}

extension UIColor {

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
