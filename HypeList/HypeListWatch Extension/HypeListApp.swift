//
//  HypeListApp.swift
//  HypeListWatch Extension
//
//  Created by paige on 2021/09/26.
//

import SwiftUI

@main
struct HypeListApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
