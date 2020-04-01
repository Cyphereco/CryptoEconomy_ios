//
//  AppConfig.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/1.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI
import Foundation

class AppConfig {
    static let accentColorLight: Color = .blue
    static let accentColorDark: Color = .orange
    static let colorScaleLight: Double = 224/255
    static let colorScaleDark: Double = 32/255

    static func getAccentColor(colorScheme: ColorScheme) -> Color {
        return colorScheme == .dark ? accentColorDark : accentColorLight
    }
    
    static func getMenuBackgroundColor(colorScheme: ColorScheme) -> Color {
        if (colorScheme == .dark) {
            return Color(red: colorScaleDark, green: colorScaleDark, blue: colorScaleDark)
        }
        return Color(red: colorScaleLight, green: colorScaleLight, blue: colorScaleLight)
    }
}
