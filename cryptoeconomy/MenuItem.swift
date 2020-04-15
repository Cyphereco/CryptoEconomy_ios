//
//  MenuItem.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/31.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct MenuItem: View {
    var itemLabel: String = ""
    var completion: () -> Void = {}
        
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: self.completion) {
                Text(self.itemLabel)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
            }
            .padding(.leading, 20)
            Divider().padding(.all, 0)
        }
    }
}

struct MenuItem_Previews: PreviewProvider {
    static var previews: some View {
        MenuItem(itemLabel: "Option", completion: {})
    }
}
