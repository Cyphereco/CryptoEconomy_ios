//
//  BackgroundView.swift
//  cryptoeconomy
//
//  Created by FuYuanChuang on 2020/4/11.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct BackgroundView<Content: View>: View {
    private var content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        Color.white
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .overlay(content)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
