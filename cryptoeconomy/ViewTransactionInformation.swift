//
//  ViewTransactionRecord.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/11.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ViewTransactionInformation: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appConfig: AppConfig
    @Environment(\.colorScheme) var colorScheme
    @State var showAlert = false
    @State var msg = ""
    @State var showLocalCurrency = false

    let transactionInfo = NSLocalizedString("transaction_information", comment: "")
    let date = NSLocalizedString("date", comment: "")
    let time = NSLocalizedString("time", comment: "")
    let result = NSLocalizedString("result", comment: "")
    let confirmations = NSLocalizedString("confirmations", comment: "")
    let sender = NSLocalizedString("sender", comment: "")
    let sendAmount = NSLocalizedString("send_amount", comment: "")
    let recipient = NSLocalizedString("recipient", comment: "")
    let recvAmount = NSLocalizedString("received_amount", comment: "")
    let fees = NSLocalizedString("fees", comment: "")
    let labelShowLocalCurrency = NSLocalizedString("show_local_currency", comment: "")
    let transactionId = NSLocalizedString("transaction_id", comment: "")

    var body: some View {
        NavigationView {
            GeometryReader {geometry in
                VStack {
                    HStack {
                        VStack(alignment: .trailing) {
                            Text("\(self.date)/\(self.time) :")
                                .font(.headline)
                            Text("\(self.result) :")
                                .font(.headline)
                        }
                        .frame(width: geometry.size.width / 4)


                        VStack(alignment: .leading) {
                            Text("04/11/20 10:55:21")
                            Text("1 \(self.confirmations)")
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            HStack {
                                Image("raw_data")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24.0,height:24.0)
                                Image("delete")
                                    .padding(.leading, 5.0)
                            }
                        }
                        .foregroundColor(AppConfig.getAccentColor(colorScheme: self.colorScheme))
                        .frame(width: geometry.size.width / 4)
                    }
                    .padding([.top, .leading, .trailing])

                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("\(self.sender) :")
                                .font(.headline)
                            Text("1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab")
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)
                                .padding(.leading)
                                .frame(height: 50)
                        }
                        HStack {
                            Text("\(self.sendAmount) :")
                                .font(.headline)
                            Spacer()
                            Text("0.1234 5678 BTC")
                        }
                    }.padding([.top, .leading, .trailing])
                    Divider()

                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("\(self.recipient) :")
                                .font(.headline)
                            Text("1QEma6prBJscNqw7s3t8EGFcx3zF7mzWab")
                                .multilineTextAlignment(.leading)
                                .lineLimit(3)
                                .padding(.leading)
                            .frame(height: 50)
                        }
                        HStack {
                            Text("\(self.recvAmount) :")
                                .font(.headline)
                            Spacer()
                            Text("0.1234 4678 BTC")
                        }
                        Divider()
                    }.padding()

                    HStack {
                        Text("\(self.fees) :")
                            .font(.headline)
                        Spacer()
                        Text("0.0000 1 BTC")
                    }.padding(.horizontal)

                    HStack {
                        Spacer()
                        Image("pay")
                            .foregroundColor(AppConfig.getAccentColor(colorScheme: self.colorScheme))
                        Text(self.labelShowLocalCurrency).lineLimit(1).font(.headline)
                        Toggle("", isOn: self.$showLocalCurrency)
                            .labelsHidden()
                    }.padding([.leading, .bottom, .trailing])

                    Spacer()
                    HStack {
                        Text("\(self.transactionId):")
                            .font(.headline)
                        Image("eye")
                            .foregroundColor(AppConfig.getAccentColor(colorScheme: self.colorScheme))
                        Spacer()
                    }.padding(.horizontal)
                    Text("5dc7bee70b2d4d486d2e9ca997354e6909769049b2d971dc4034e2c03df909c7").padding(.horizontal).frame(height: 50.0)
                    HStack {
                        VStack {
                            Image(systemName: "backward").font(.system(size: 19)).padding(4)
                        }
                        .onTapGesture {
                            self.showAlert = true
                            self.msg = "Previous"
                        }
                        .alert(isPresented: self.$showAlert){
                            Alert(title: Text(self.msg))
                        }
                        .padding(.bottom)
                        .foregroundColor(AppConfig.getAccentColor(colorScheme: self.colorScheme))
                        .frame(width: geometry.size.width/2)

                        VStack {
                            Image(systemName: "forward").font(.system(size: 19)).padding(4)
                        }
                        .onTapGesture {
                            self.showAlert = true
                            self.msg = "Next"
                        }
                        .alert(isPresented: self.$showAlert){
                            Alert(title: Text(self.msg))
                        }
                        .padding(.bottom)
                        .foregroundColor(AppConfig.getAccentColor(colorScheme: self.colorScheme))
                        .frame(width: geometry.size.width/2)
                   }
                }
            }
            .navigationBarTitle(Text(self.transactionInfo), displayMode: .inline)
            .navigationBarItems(trailing:
                Image("clear")
                    .foregroundColor(AppConfig.getAccentColor(colorScheme:  self.colorScheme))
                    .onTapGesture {
                    self.presentationMode.wrappedValue.dismiss()
                })
        }
    }
}

struct ViewTransactionRecord_Previews: PreviewProvider {
    static var previews: some View {
        ViewTransactionInformation().environmentObject(AppConfig())
    }
}
