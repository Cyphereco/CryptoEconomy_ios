//
//  AppUIComponents.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/17.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct RowButton: View {
    var text: String
    let completion: () -> Void
    
    var body: some View {
        Button(action: {
            self.completion()
        }){
            HStack {
                Text(text)
                Spacer()
            }
        }
    }
}

struct TappableBackground: ViewModifier {
    let completion: ()->Void
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
         ZStack {
             GeometryReader {_ in
                 EmptyView()
             }
             .background(Color.white.opacity(0.001))
             
            content
         }
        .onTapGesture {
            self.completion()
        }
    }
}

extension View {
    func onTapBackground(_ completion: @escaping ()->Void ) -> some View {
        self.modifier(TappableBackground(completion: completion))
    }
}

struct SideMenu: ViewModifier {
    let isOpened: Bool
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            HStack {
                Spacer()

                content
                .frame(maxWidth: geometry.size.width / 3 * 2)
                .background(self.colorScheme == .dark ? Color.black : Color.white)
                .offset(x: self.isOpened ? 0 : geometry.size.width * 2)
                .animation(.easeInOut)
            }
            Spacer()
        }
    }
}

extension View {
    func asSideMenu(isOpened: Bool) -> some View {
        self.modifier(SideMenu(isOpened: isOpened))
    }
}

struct SwipableTabs: ViewModifier {
    @Binding var currentTab: Int
    let totalTabs: Int
    @State var keyboard = KeyboardResponder()

    func body(content: Content) -> some View {
        ZStack {
            GeometryReader {_ in
                EmptyView()
            }
            .background(Color.white.opacity(0.001))
            
            content
        }
        .gesture(DragGesture()
            .onEnded { gesture in
                if gesture.translation.width > 100 {
                    withAnimation {
                        if self.currentTab > 0 {
                            self.currentTab -= 1
                        }
                    }
                }
                else if gesture.translation.width < -100 {
                    withAnimation {
                        if self.currentTab < self.totalTabs - 1 {
                            self.currentTab += 1
                        }
                    }
                }
            })
    }
}

extension View {
    func swipableTabs(currentTab: Binding<Int>, totalTabs: Int) -> some View {
        self.modifier(SwipableTabs(currentTab: currentTab, totalTabs: totalTabs))
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct KeyboardResponsiveModifier: ViewModifier {
  @State private var offset: CGFloat = 0

  func body(content: Content) -> some View {
    content
      .padding(.bottom, offset)
      .onAppear {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notif in
          let value = notif.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
          let height = value.height
          let bottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom
          self.offset = height - (bottomInset ?? 0)
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notif in
          self.offset = 0
        }
    }
  }
}

extension View {
  func keyboardResponsive() -> ModifiedContent<Self, KeyboardResponsiveModifier> {
    return modifier(KeyboardResponsiveModifier())
  }
}