//
//  AppUIComponents.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/4/17.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI
import CodeScanner
import Introspect

class TextFieldObserver: NSObject {
    @objc
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(nil)
    }
}

struct TextView: UIViewRepresentable {
    var placeholder: String
    @Binding var text: String

    var minHeight: CGFloat
    @Binding var calculatedHeight: CGFloat
    @Environment(\.colorScheme) var colorScheme
    
    let editable: Bool
    let onEditingChanged: ()->Void

    init(placeholder: String, text: Binding<String>, minHeight: CGFloat, calculatedHeight: Binding<CGFloat>, editable: Bool) {
        self.init(placeholder: placeholder, text: text, minHeight: minHeight, calculatedHeight: calculatedHeight, editable: editable, onEditingChanged: {})
    }

    init(placeholder: String, text: Binding<String>, minHeight: CGFloat, calculatedHeight: Binding<CGFloat>, editable: Bool, onEditingChanged: @escaping ()->Void) {
        self.placeholder = placeholder
        self._text = text
        self.minHeight = minHeight
        self._calculatedHeight = calculatedHeight
        self.editable = editable
        self.onEditingChanged = onEditingChanged
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator

        // Decrease priority of content resistance, so content would not push external layout set in SwiftUI
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        textView.isScrollEnabled = true
        textView.isEditable = self.editable
        textView.isUserInteractionEnabled = true

        // Set the placeholder
        textView.text = placeholder
        textView.font = .systemFont(ofSize: 18)
        textView.textColor = UIColor.lightGray

        return textView
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        DispatchQueue.main.async {
            if self.text.isEmpty {
                textView.text = self.placeholder
                textView.textColor = UIColor.lightGray
                UIApplication.shared.endEditing()
            }
            else {
                textView.text = self.text
                textView.textColor = self.colorScheme == .dark ? .white : .black
            }
            self.recalculateHeight(view: textView)
        }
    }

    func recalculateHeight(view: UIView) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if minHeight < newSize.height && $calculatedHeight.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                self.$calculatedHeight.wrappedValue = newSize.height // !! must be called asynchronously
            }
        } else if minHeight >= newSize.height && $calculatedHeight.wrappedValue != minHeight {
            DispatchQueue.main.async {
                self.$calculatedHeight.wrappedValue = self.minHeight // !! must be called asynchronously
            }
        }
    }

    class Coordinator : NSObject, UITextViewDelegate {

        var parent: TextView

        init(_ uiTextView: TextView) {
            self.parent = uiTextView
        }

        func textViewDidChange(_ textView: UITextView) {
            // This is needed for multistage text input (eg. Chinese, Japanese)
            if textView.markedTextRange == nil {
                parent.text = textView.text ?? String()
                parent.recalculateHeight(view: textView)
            }
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            self.parent.onEditingChanged()

            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.white
            }
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = parent.placeholder
                textView.textColor = UIColor.lightGray
            }
        }
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

struct QRCodeScanner: View {
    let closeScanner: ()->Void
    let completion: (Result<String, CodeScannerView.ScanError>)->Void
    
    var body: some View {
        ZStack {
            CodeScannerView(codeTypes: [.qr], simulatedData: "Some simulated data", completion: self.completion)

            ZStack {
                GeometryReader { _ in
                    EmptyView()
                }
                .background(Color.black)

                GeometryReader { _ in
                    EmptyView()
                }
                .frame(width: 250, height: 250)
                .background(Color.white.opacity(0.2))
            }
            .opacity(0.4)

            VStack {
                VStack {
                    Image(systemName: "minus").imageScale(.large)
                    HStack {
                        Spacer()
                        Text(AppStrings.scanningQrCode).font(.headline).padding([.leading, .trailing, .bottom])
                        Spacer()
                    }
                }.background(Color.gray)
                Spacer()
                Button(action: {
                    self.closeScanner()
                }){
                    Image(systemName: "multiply.circle.fill")
                    .font(.largeTitle)
                    .padding()
                }
            }
        }

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

struct AddKeyboardDismissButton: ViewModifier {
    @State var keyboardActive = false

    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                Spacer()
                if self.keyboardActive {
                    HStack {
                        Spacer()
                        Button(action: {
                            UIApplication.shared.endEditing()
                        }){
                            Image(systemName: "keyboard.chevron.compact.down").padding(.top, 5)
                        }.frame(width: 44, height: 44)
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .clipShape(Circle())
                    }.padding(.horizontal)
                }
            }.keyboardResponsive()
        }.isKeyboardActive(keyboardActive: self.$keyboardActive)
    }
}

extension View {
    func addKeyboardDismissButton() -> some View {
        self.modifier(AddKeyboardDismissButton())
    }
}

struct SelectAllTextOnFocus: ViewModifier {
    private let textFieldObserver = TextFieldObserver()

    func body(content: Content) -> some View {
        content
            .introspectTextField { textField in
                textField.addTarget(
                    self.textFieldObserver,
                    action: #selector(TextFieldObserver.textFieldDidBeginEditing),
                    for: .editingDidBegin
            )}
    }
}

extension TextField {
    func selectAllTextOnFocus() -> some View {
        self.modifier(SelectAllTextOnFocus())
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
                ViewToastMessage(message: self.message, delay: 3.5, show: self.$showToastMessage).keyboardResponsive()
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

struct IsKeyboardActive: ViewModifier {
    @Binding var keyboardActive: Bool
    @State private var offset: CGFloat = 0

    func body(content: Content) -> some View {
        content
        .padding(.bottom, offset)
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notif in
                self.keyboardActive = true
            }

            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notif in
                self.keyboardActive = false
            }
        }
    }
}

extension View {
    func isKeyboardActive(keyboardActive: Binding<Bool>) -> ModifiedContent<Self, IsKeyboardActive> {
        return modifier(IsKeyboardActive(keyboardActive: keyboardActive))
    }
}
