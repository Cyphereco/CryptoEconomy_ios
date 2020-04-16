//
//  BackgroundView.swift
//  cryptoeconomy
//
//  Created by FuYuanChuang on 2020/4/11.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct BackgroundView: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
         ZStack {
             GeometryReader {_ in
                 EmptyView()
             }
             .background(Color.white.opacity(0.001))
             
             content
         }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

extension View {
    func setDismissKeyboardBackground() -> some View {
        self.modifier(BackgroundView())
    }
}
