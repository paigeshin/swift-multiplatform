//
//  HypedListTVApp.swift
//  HypedListTV
//
//  Created by paige on 2021/10/02.
//

import SwiftUI

@main
struct HypedListTVApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    DataController.shared.loadData()
                    DataController.shared.getDiscoverEvents()
                }
        }
    }
}
