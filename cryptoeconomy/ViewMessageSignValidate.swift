
//
//  TabView.swift
//  UITrial
//
//  Created by Quark on 2020/4/24.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct ViewMessageSignValidate: View {
    @State var tabPage = 0
    @GestureState  var dragOffset = CGSize.zero

    var body: some View {
        GeometryReader{ geometry in
            ZStack {
                GeometryReader {_ in
                    EmptyView()
                }
                .background(Color.white.opacity(0.001))
                
                VStack (alignment: .leading){
                    HStack {
                        HStack {
                            Spacer()
                            Text(AppStrings.sign)
                            Spacer()
                        }
                        .onTapGesture{
                            self.tabPage = 0
                        }
                        HStack {
                            Spacer()
                            Text(AppStrings.validate)
                            Spacer()
                        }
                        .onTapGesture{
                            self.tabPage = 1
                        }
                    }.padding(.top)
                    
                    self.line.frame(width: geometry.size.width/2)
                        .offset(x: self.tabPage == 0 ? 0 : geometry.size.width/2)
                        .offset(x: -self.dragOffset.width)
                        .animation(.default)

                    
                    ZStack(alignment: .center) {
                        VStack {
                            Spacer()
                            Text("Sign message")
                            Spacer()
                        }
                        .frame(width: geometry.size.width)
                        .background(Color.yellow)
                        .offset(x: self.tabPage == 0 ? 0 : -geometry.size.width)
                        .animation(.default)

                        VStack {
                            Spacer()
                            Text("Validate signature")
                            Spacer()
                        }
                        .frame(width: geometry.size.width)
                        .background(Color.orange)
                        .offset(x: self.tabPage == 1 ? 0 : geometry.size.width)
                        .animation(.default)
                    }
                    .offset(x: self.dragOffset.width)

                }
            }
            .gesture(DragGesture()
               .updating(self.$dragOffset, body: { (value, state, transaction) in
                   state = value.translation
               })
            .onEnded { gesture in
                if self.tabPage == 1 && gesture.translation.width > 100 {
                    self.tabPage = 0
                }
                if self.tabPage == 0 && gesture.translation.width < -100 {
                    self.tabPage = 1
                }
            })
        }
    }
    
    var line: some View {
        VStack {
            Divider().setCustomDecoration(.backgroundReversed)
        }.padding(.horizontal)
    }
}

struct TabPagesView_Previews: PreviewProvider {
    static var previews: some View {
        ViewMessageSignValidate()
    }
}
