//
//  HypeListApp.swift
//  Shared
//
//  Created by paige on 2021/09/22.
//

import SwiftUI

@main
struct HypeListApp: App {
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
