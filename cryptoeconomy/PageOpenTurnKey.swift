//
//  PageOpenTurnKey.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/29.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct PageOpenTurnKey: View {
    @State var showMenu = false
    @State var requestHint: String = "Read General Information"
    let extraSpace: String = "       "
    var body: some View {
        NavigationView {
            GeometryReader {geometry in
                ZStack(alignment: .trailing) {
                    VStack{
                        HStack(alignment: .center, spacing: 20) {
                            Spacer()
                        }.frame(minWidth: .zero, idealWidth: .none, maxWidth: .infinity, minHeight: 80, idealHeight: .none, maxHeight: 160, alignment: .center)
                        Image("cyphereco_label").resizable().scaledToFit().frame(width: 100, height: 100)
                        Text("OpenTurnKey")
                            .fontWeight(.bold)
                        Text("(" + self.requestHint + ")").padding()
                        VStack(alignment: .center, spacing: 20) {
                            Spacer()
                            Button(action: {
                                self.requestHint = "Read General Information"
                            }) {
                                Text(self.extraSpace + "Make Request" + self.extraSpace)
                                    .font(.system(size: 20))
                                .fontWeight(.bold)
                                .padding(12)
                                    .background(Color.init(red: 0.5, green: 0.75, blue: 1))
                                .cornerRadius(24)
                                .foregroundColor(.black)
                            }
                            Spacer()
                        }.frame(minWidth: .zero, idealWidth: .none, maxWidth: .infinity, minHeight: 80, idealHeight: .none, maxHeight: 160, alignment: .center)
                    }.disabled(self.showMenu)
                    if (self.showMenu) {
                        SideMenuOpenTurnKey(showMenu: self.$showMenu, requestHint: self.$requestHint)
                            .frame(width: geometry.size.width/2)
                            .transition(.move(edge: .top))
                    }
                }
            }
            .navigationBarTitle(Text("OpenTurnKey"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                withAnimation {
                    self.showMenu.toggle()
                }
            }) {
                if (showMenu) {
                    Image("menu_collapse")
                }
                else {
                    Image("menu_expand")
                }
            })
        }
    }
}

struct PageOpenTurnKey_Previews: PreviewProvider {
    static var previews: some View {
        PageOpenTurnKey()
    }
}
