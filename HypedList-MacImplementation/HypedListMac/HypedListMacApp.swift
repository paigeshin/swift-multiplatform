//
//  HypedListMacApp.swift
//  HypedListMac
//
//  Created by paige on 2021/09/28.
//

import SwiftUI

@main
struct HypedListMacApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    DataController.shared.loadData()
                    DataController.shared.getDiscoverEvents()
                }
                .frame(minWidth: 800, minHeight: 500)
        }
    }
}
