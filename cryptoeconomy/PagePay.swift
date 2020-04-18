//
//  PagePay.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/30.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct PagePay: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appConfig: AppConfig
    
    @ObservedObject var otkNpi = OtkNfcProtocolInterface()
    @State var alertUseFixedAddress = false

    var body: some View {
        NavigationView {
            GeometryReader {geometry in
                ZStack(alignment: .trailing) {
                    VStack(alignment: .trailing) {
                        TextEstFeesInfo(currencySelection: self.$appConfig.currencySelection, fees: self.$appConfig.fees)
                            .padding([.top, .trailing], 20.0)
                        
                        Spacer()
                        
                        TextFieldBtcAddress(address: self.$appConfig.payeeAddr)
                            .padding(.horizontal, 20.0)
                            .disabled(self.appConfig.useFixedAddress)
                            .onTapGesture {
                                self.alertUseFixedAddress = true
                            }
                            .alert(isPresented: self.$alertUseFixedAddress){
                                Alert(title: Text("use_fixed_address"))
                            }

                        Toggle(isOn: self.$appConfig.useAllFunds){
                            HStack {
                                Spacer()
                                Text(AppStrings.useAllFunds).font(.footnote)
                            }
                        }.padding(.horizontal, 20.0).padding(.top, 50)
                        
                        TextFieldPayAmount(localCurrency: self.$appConfig.currencySelection, strAmountBtc: "", strAmountFiat: "").keyboardType(.decimalPad)
                            .padding(.horizontal, 20.0)
                        
                        Toggle(isOn: self.$appConfig.authByPin){
                            HStack {
                                Spacer()
                                Text(AppStrings.authByPin).font(.footnote)
                            }
                        }.padding(.horizontal, 20.0).padding(.top, 40).padding(.bottom, 10)
                        
                        Button(action: {
                            self.otkNpi.beginScanning(completion: {})
                        }) {
                            HStack{
                                if (self.appConfig.authByPin) {
                                    Image(systemName: "ellipsis").font(.system(size: 19)).padding(4)
                                }
                                else {
                                    Image("fingerprint")
                                }
                                Text("sign_payment")
                                    .font(.system(size: 20))
                                .fontWeight(.bold)
                            }
                            .padding(12)
                            .background(AppConfig.getAccentColor(colorScheme: self.colorScheme))
                            .cornerRadius(24)
                            .foregroundColor(.white)
                        }
                        .padding(.trailing, 20.0)
                        .padding(.bottom, 40)
                    }
                }
            }
            .onTapBackground({
                UIApplication.shared.endEditing()
            })
            .navigationBarTitle(Text("pay"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                withAnimation {
                    self.appConfig.interacts = .menuPay
                }
            }) {
                Image("menu")
            })
        }
    }
}

struct PagePay_Previews: PreviewProvider {
    static var previews: some View {
        PagePay().environmentObject(AppConfig())
    }
}
