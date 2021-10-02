//
//  HypedListApp.swift
//  HypedList
//
//  Created by ZappyCode on 10/17/20.
//

import SwiftUI

@main
struct HypedListApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    DataController.shared.loadData()
                    DataController.shared.getDiscoverEvents()
                    PhoneToWatchDataController.shared.setupSession()
                }
        }
    }
}
