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
            Text(self.itemLabel)
                .frame(alignment: .leading)
            Spacer()
            Toggle("", isOn: self.$onState)
                .labelsHidden()
                .frame(alignment: .trailing)
        }
    }
}

struct MenuItemToggle_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemToggle(itemLabel: "Enable Option", onState: .constant(true))
    }
}
