//
//  MenuItemToggle.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/1.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct MenuItemToggle: View {
    var itemLabel: String = ""
    @Binding var onState: Bool
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Toggle(isOn: self.$onState) {
                    Text(self.itemLabel)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(nil)
                        .foregroundColor(AppConfig.getAccentColor(colorScheme: self.colorScheme))
                }
                .padding(.leading, 20)
                Divider().padding(.all, 0)
            }
            Spacer()
        }
    }
}

struct MenuItemToggle_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemToggle(itemLabel: "Enable Option", onState: .constant(true))
    }
}
