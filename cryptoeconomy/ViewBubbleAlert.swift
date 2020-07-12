//
//  ViewToastMessage.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/13.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ViewBubbleAlert: View {

    @State var message: String
    @State var delay: Double
    @Binding var show: Bool

    var body: some View {
        VStack {
            Spacer()
            if (self.show) {
                Text(message)
                    .font(.system(size: 22))
                    .lineLimit(8)
                    .multilineTextAlignment(.center)
                    .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                        self.show = false
                    }
                })
                .frame(minWidth: 80)
                .padding(12)
                .setCustomDecoration(.bubble)
                .opacity(self.show ? 1 : 0)
            }
            Spacer().frame(maxHeight: 40)
        }
    }
}

struct ViewBubbleMessage_Previews: PreviewProvider {
    static var previews: some View {
        ViewBubbleAlert(message: "Hello World!", delay: 1.5, show: .constant(true))
    }
}
