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
    @Binding var showFiat: Bool
    @EnvironmentObject var appController: AppController

    var body: some View {
        Text(!showFiat ? AppTools.btcToFormattedString(self.btc) : AppTools.fiatToFormattedString(AppTools.btcToFiat(self.btc, currencySelection: self.appController.currencySelection))) +
            Text(showFiat ? " \(self.appController.getLocalCurrency().label)" : " BTC")
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
    @State var showFiat = false
    
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
                                (Text("=> ") + Text("recipient").font(.subheadline)).padding(.horizontal)
                            }
                            BtcAddress(btcAddr: self.appController.payee).padding(.top, -2)
                            Text("")
                            HStack{
                                Text("sender") + Text(" =>").font(.subheadline)
                                Spacer()
                            }
                            BtcAddress(btcAddr: self.appController.payer).padding(.top, -2)
                            Text("")
                        }
                        Toggle(isOn: self.$showFiat){
                            HStack {
                                Spacer()
                                Text(AppStrings.showLocalCurrency).font(.headline).padding(.vertical)
                            }.padding(.bottom, -10)
                        }
                        Group {
                            HStack {
                                Text("send_amount") + Text(":").font(.subheadline)
                                Spacer()
                                AmountBtcFiat(btc: self.appController.getAmountSent(), showFiat: self.$showFiat).font(.headline).foregroundColor(.blue)
                            }
                            HStack {
                                Text("-)") + Text("fees") + Text(": ").font(.subheadline)
                                Spacer()
                                AmountBtcFiat(btc: self.appController.fees, showFiat: self.$showFiat)
                                    .font(.headline).foregroundColor(.gray)
                            }.addUnderline().padding(.bottom, -10)
                            HStack {
                                Text("received_amount") + Text(":").font(.subheadline)
                                Spacer()
                                AmountBtcFiat(btc: self.appController.getAmountReceived(), showFiat: self.$showFiat)
                                .font(.headline).foregroundColor(.blue)
                            }
                        }
                    }.font(.callout).padding()
                    HStack {
                        Text("Estimated Time") + Text(":").font(.headline)
                        Spacer()
                        Text(self.appController.getEstTime()) + Text(" ") + Text("minutes")
                        }.padding().addUnderline()
                    HStack {
                        Button(action: {
                            self.closeDialog()
                            self.onCancel()
                        }){
                            Text("cancel")
                        }.frame(width: geometry.size.width * 0.4)
                        Text("").padding()
                        Button(action: {
                            self.closeDialog()
                            self.onConfirm()
                        }){
                            Text("ok")
                        }.frame(width: geometry.size.width * 0.4)
                    }.padding(.top, -10)
                }
                .setCustomDecoration(.backgroundNormal)
                .setCustomDecoration(.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .frame(width: geometry.size.width * 0.8, height: 440)
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
