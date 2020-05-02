//
//  DialogEnterNote.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/5/1.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct DialogWriteNote: View {
    let showDialog: Bool
    let closeDialog: ()->Void

    @State var pin = ""
    var handler: (String) -> Void
    
    @State var note = ""
    @State var noteHeight: CGFloat = 10
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
                .onTapGesture {
                    if self.keyboardActive {
                        UIApplication.shared.endEditing()
                    }
                    self.closeDialog()
                    self.note = ""
                }

                VStack {
                    Text(AppStrings.writeNote).font(.headline)
                    TextView(placeholder: "Enter Note (No more than 64 characters)", text: self.$note, minHeight: self.noteHeight, calculatedHeight: self.$noteHeight, editable: true, onEditingChanged: {
                            if self.note.count > 64 {
                                self.note = String(self.note.prefix(64))
                            }
                        })
                        .frame(height: self.noteHeight < 120 ? self.noteHeight : 120)
                        .addUnderline()
                        .padding()
                    Button(action: {
                        self.closeDialog()
                        self.handler(self.note)
                        self.note = ""
                    }){
                        Text("ok")
                    }
                }
                .padding()
                .setCustomDecoration(.backgroundNormal)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .frame(width: 320)
                .disabled(!self.showDialog)
                .opacity(self.showDialog ? 1 : 0)
                .animation(.easeInOut)
            }
       }.isKeyboardActive(keyboardActive: self.$keyboardActive)
    }
}

struct DialogWriteNote_Previews: PreviewProvider {
    static var previews: some View {
        DialogWriteNote(showDialog: true, closeDialog: {}, handler: {note in }, note: "")
    }
}
