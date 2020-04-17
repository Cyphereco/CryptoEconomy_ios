//
//  SideMenuPayPage.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/31.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

extension String {
   func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

struct SideMenuPay: View {
    let isOpened: Bool
    let closeMenu: ()->Void
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appConfig: AppConfig
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack (alignment: .leading) {
                    Text(AppStrings.setCurrency)
                        .padding()
                        .onTapGesture{
                            withAnimation {
                                self.closeMenu()
                                self.appConfig.interacts = .configLocalCurrency
                            }
                        }
                    Text(AppStrings.setFees)
                        .padding()
                        .onTapGesture{
                            withAnimation {
                                self.closeMenu()
                                self.appConfig.interacts = .configFees
                            }
                        }
                    MenuItemToggle(itemLabel: AppStrings.feesIncluded, onState: self.$appConfig.feesIncluded)
                        .frame(width: 200)
                        .padding(.horizontal).padding(.bottom, 10)
                    MenuItemToggle(itemLabel: AppStrings.useFixAddress, onState: self.$appConfig.useFixAddress)
                        .frame(width: 200)
                        .padding(.horizontal).padding(.bottom, 6)
                    Text(AppStrings.userGuide)
                        .padding()
                        .onTapGesture{
                            withAnimation {
                                self.closeMenu()
                            }
                        }
                    Text(AppStrings.about)
                        .padding()
                        .onTapGesture{
                            withAnimation {
                                self.closeMenu()
                            }
                        }
                }
                .background(self.colorScheme == .dark ? Color.black : Color.white)
                .offset(x: self.isOpened ? 0 : geometry.size.width * 2)
                .animation(.easeInOut)
            }
            Spacer()
        }
    }
}

struct SideMenuPay_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuPay(isOpened: true, closeMenu: {})
            .environmentObject(AppConfig())
    }
}
