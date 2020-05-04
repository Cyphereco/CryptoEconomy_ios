//
//  DialogConfirmPayment.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/5/3.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct BtcAddress: View {
    let btcAddr: String
    @State var textHeight: CGFloat = 0
    
    var body: some View {
        TextView(placeholder: "", text: .constant(self.btcAddr), minHeight: self.textHeight, calculatedHeight: self.$textHeight, editable: false).frame(height: self.textHeight).padding(.top, -13)
    }
}

struct AmountBtcFiat: View {
    let btc: Double
    @EnvironmentObject var appController: AppController

    var body: some View {
        Text(AppTools.btcToFormattedString(self.btc)) +
            Text(" / ") +
            Text(AppTools.fiatToFormattedString(AppTools.btcToFiat(self.btc, currencySelection: self.appController.currencySelection))) +
            Text(" (BTC/\(self.appController.getLocalCurrency().label))")
    }
}

struct DialogConfirmPayment: View {
    let showDialog: Bool
    let closeDialog: ()->Void

    @State var pin = ""
    var onConfirm: () -> Void
    var onCancel: () -> Void

    @EnvironmentObject var appController: AppController
    @State var keyboardActive = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                GeometryReader { _ in
                    EmptyView()
                }
                .background(Color.gray.opacity(0.8))
                .opacity(self.showDialog ? 0.5 : 0.0)
                .animation(.easeInOut)
                .onTapGesture {}
                .gesture(DragGesture())

                VStack {
                    Text("Confirm Payment").font(.headline).padding().addUnderline().padding(.bottom, -20)
                    VStack (alignment: .leading){
                        Group {
                            Text("")
                            HStack{
                                Spacer()
                                Text("(Recipient)").font(.subheadline).padding(.horizontal)
                            }
                            BtcAddress(btcAddr: self.appController.payee)
                            Text("")
                            HStack{
                                Text("(Sender)").font(.subheadline)
                                Spacer()
                            }
                            BtcAddress(btcAddr: self.appController.payer)
                            Text("")
                        }
                        Group {
                            HStack {
                                Spacer()
                                Text("Amount").font(.headline)
                            }.addUnderline().padding(.bottom, -10)
                            HStack {
                                Text("Send:").font(.subheadline)
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                AmountBtcFiat(btc: self.appController.getAmountSend()).font(.headline).foregroundColor(.blue)
                            }
                            HStack {
                                Text("Fees: ").font(.subheadline)
                                Spacer()
                            }
                            HStack {
                                Text("-)")
                                Spacer()
                                AmountBtcFiat(btc: self.appController.getAmountSend() - self.appController.fees).foregroundColor(.blue)
                            }.addUnderline().padding(.bottom, -10)
                            HStack {
                                Text("Received: ").font(.subheadline)
                                Spacer()
                            }
                            HStack {
                                Text("=")
                                Spacer()
                                
                                AmountBtcFiat(btc: self.appController.fees)
                                .foregroundColor(.blue)
                            }
                        }
                    }.font(.callout).padding()
                    HStack {
                        Text("Est. Time: ").font(.headline)
                        Spacer()
                        Text(self.appController.getEstTime()) + Text(" Min.")
                    }.padding()
                    HStack {
                        Button(action: {
                            self.closeDialog()
                            self.onCancel()
                        }){
                            Text("cancel")
                        }
                        .frame(width: geometry.size.width * 0.4)
                        Text("").padding()
                        Button(action: {
                            self.closeDialog()
                            self.onConfirm()
                        }){
                            Text("ok")
                        }
                        .frame(width: geometry.size.width * 0.4)
                    }
                }
                .setCustomDecoration(.backgroundNormal)
                .setCustomDecoration(.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .frame(width: geometry.size.width * 0.8)
                .disabled(!self.showDialog)
                .opacity(self.showDialog ? 1 : 0)
                .animation(.easeInOut)
            }
       }.isKeyboardActive(keyboardActive: self.$keyboardActive)
    }
}

struct DialogConfirmPayment_Previews: PreviewProvider {
    static var previews: some View {
        DialogConfirmPayment(showDialog: true, closeDialog: {}, onConfirm: {}, onCancel: {}).environmentObject(AppController())
    }
}
