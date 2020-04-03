//
//  PageHistory.swift
//  cryptoeconomy
//
//  Created by Quark on 2020/3/30.
//  Copyright © 2020 Cyphereco OU. All rights reserved.
//

import SwiftUI

struct PageHistory: View {
    @State var showsAlert = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appData: AppData

    var body: some View {
        NavigationView {
            VStack {
                if (self.appData.dataSetRecordTransaction.count < 1) {
                    Text("No Transaction Record")
                }
                else {
                    List {
                        ForEach (0 ..< self.appData.dataSetRecordTransaction.count) {
                            ListItemTransaction(recordTransaction: self.appData.dataSetRecordTransaction[$0])
                        }
                    }
                }
            }
            .navigationBarTitle(Text("History"), displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {self.showsAlert.toggle()}) {
                    Image("delete_all")
                }
                .alert(
                    isPresented: $showsAlert,
                    content: {
                        Alert(title: Text("Clear History"),
                              message: Text("Delete all trnsaction records?"),
                              primaryButton: .default(
                                Text("Delete"),
                                action: {print("Clear History")}
                            ),
                              secondaryButton: .default(
                                Text("Cancel"),
                                action: {print("Cancel Clear")}
                            )
                        )
                    }
                )
            )
        }
    }
}

struct PageHistory_Previews: PreviewProvider {
    static var previews: some View {
        PageHistory().environmentObject(AppData())
    }
}
