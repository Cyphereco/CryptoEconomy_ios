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
    @State var onState: Bool = false

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Toggle(isOn: self.$onState) {
                    Text(self.itemLabel)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(nil)
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
        MenuItemToggle(itemLabel: "Use All Funds", onState: false)
    }
}
