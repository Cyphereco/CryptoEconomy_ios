//
//  ViewToastMessage.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/13.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ViewToastMessage: View {

    @State var message: String
    @State var delay: Double
    @Binding var show: Bool
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Spacer()
            if (self.show) {
                Text(message)
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
                    .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                        self.show = false
                    }
                })
                .frame(minWidth: 80)
                .padding(12)
                .background(Color.gray)
                .cornerRadius(8)
                .foregroundColor(.white)
                .opacity(self.show ? 1 : 0)
            }
            Spacer().frame(maxHeight: 40)
        }
    }
}

struct ViewToastMessage_Previews: PreviewProvider {
    static var previews: some View {
        ViewToastMessage(message: "Hello World!", delay: 1.5, show: .constant(true))
    }
}