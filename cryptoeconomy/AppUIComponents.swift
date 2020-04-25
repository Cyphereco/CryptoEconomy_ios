//
//  AppUIComponents.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/17.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI
import Introspect

class TextFieldObserver: NSObject {
    @objc
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(nil)
    }
}

struct CopyButton: View {
    var copyString: String
    var completion: ()->Void
    
    var pasteboard = UIPasteboard.general
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.pasteboard.string = self.copyString
                self.completion()
            }
        }){
            Image("copy")
        }
    }
}

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

struct ImageQRCode: View {
    var text: String
    
    var body: some View {
        Image(uiImage: UIImage(data: getQrCodeData(str: self.text))!).resizable().frame(width: self.getSize(), height: self.getSize())
    }
    
    func getSize() -> CGFloat {
        let size = self.text.count > 32 ? self.text.count > 128 ? 200 : 150 : 100
        return CGFloat(size)
    }
    
    func getQrCodeData(str: String) -> Data {
        let filter = CIFilter(name: "CIQRCodeGenerator")
        let data = str.data(using: .ascii, allowLossyConversion: false)
        filter?.setValue(data, forKey: "inputMessage")
        let image = filter?.outputImage
        let uiimage = UIImage(ciImage: image!)
        return uiimage.pngData()!
    }
}

enum CustomDecoration {
    case accentColor
    case backgroundNormal
    case backgroundReversed
    case foregroundNormal
    case foregroundAccent
    case foregourndWhite
    case roundedButton
    case toast
}

extension View {
   func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            return AnyView(content(self))
        } else {
            return AnyView(self)
        }
    }
}

struct SetCustomDecoration: ViewModifier {
    let decoration: CustomDecoration
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .if(self.decoration == .accentColor) { cnt in
                cnt.accentColor(AppController.shared.getAccentColor(self.colorScheme))
            }
            .if(self.decoration == .backgroundNormal) { cnt in
                cnt.background(self.colorScheme == .light ? Color.white : Color.black)
            }
            .if(self.decoration == .backgroundReversed) { cnt in
                cnt.background(self.colorScheme == .dark ? Color.white : Color.black)
            }
            .if(self.decoration == .foregroundNormal) { cnt in
                cnt.foregroundColor(.primary)
            }
            .if(self.decoration == .foregroundAccent) { cnt in
                cnt.foregroundColor(AppController.shared.getAccentColor(self.colorScheme))
            }
            .if(self.decoration == .foregourndWhite) { cnt in
                cnt.foregroundColor(.white)
            }
            .if(self.decoration == .roundedButton) { cnt in
                cnt.background(AppController.shared.getAccentColor(self.colorScheme))
                .cornerRadius(24)
                .foregroundColor(.white)
            }
            .if(self.decoration == .toast) { cnt in
                cnt.background(Color.gray)
                .cornerRadius(8)
                .foregroundColor(.white)
            }
    }
}

extension View {
    func setCustomDecoration(_ decoration: CustomDecoration) -> some View {
        self.modifier(SetCustomDecoration(decoration: decoration))
    }
}

struct AddSheetTitle: ViewModifier {
    let title: String
    @Environment(\.presentationMode) var presentationMode

    func body(content: Content) -> some View {
        NavigationView {
            content
            .navigationBarTitle(Text(self.title), displayMode: .inline)
           .navigationBarItems(trailing:
               Image("clear")
                   .setCustomDecoration(.foregroundAccent)
                   .onTapGesture {
                   self.presentationMode.wrappedValue.dismiss()
               })
        }
    }
}

extension View {
    func addSheetTitle(_ title: String) -> some View {
        self.modifier(AddSheetTitle(title: title))
    }
}

struct ToastMessage: ViewModifier {
    @Binding var message: String
    @Binding var showToastMessage: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if (self.showToastMessage) {
                ViewToastMessage(message: self.message, delay: 3.5, show: self.$showToastMessage)
            }
        }
    }
}

extension View {
    func toastMessage(message: Binding<String>, show: Binding<Bool>) -> some View {
        self.modifier(ToastMessage(message: message, showToastMessage: show))
    }
}

struct TappableBackground: ViewModifier {
    let completion: ()->Void

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

struct AddUnderline: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            content
            Divider().frame(height: 1).padding(.vertical, -10)
        }
    }
}

extension View {
    func addUnderline() -> some View {
        self.modifier(AddUnderline())
    }
}

struct SideMenu: ViewModifier {
    let isOpened: Bool

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            HStack {
                Spacer()

                content
                .frame(maxWidth: geometry.size.width / 3 * 2)
                .setCustomDecoration(.backgroundNormal)
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
