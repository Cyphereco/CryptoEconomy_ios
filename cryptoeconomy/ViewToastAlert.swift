//
//  ViewToastAlert.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/5/6.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ViewToastAlert: View {

    @State var message: String
    @State var delay: Double
    @Binding var show: Bool

    var body: some View {
        GeometryReader { geometry in
            VStack (alignment: .leading){
                Spacer()
                HStack {
                    Spacer()
                    Text(self.message)
                        .font(.title)
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                        .onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                            self.show = false
                        }
                    })
                    Spacer()
                }
                .frame(minHeight: 64)
                .padding(.horizontal)
                .setCustomDecoration(.toast)
                .offset(y: self.show ? 0 : geometry.size.height * 2)
                .animation(.easeIn)
            }
        }
    }
}

struct ViewToastAlert_Previews: PreviewProvider {
    static var previews: some View {
        ViewToastAlert(message: "Recipient Address is empty and amount is empty!", delay: 1.25, show: .constant(true))
    }
}
