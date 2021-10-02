//
//  ContentView.swift
//  HypeListWatch Extension
//
//  Created by paige on 2021/09/26.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var data = WatchToPhoneDataController.shared
    
    var body: some View {
        HypedEventWatchListView(hypedEvents: data.hypedEvents)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

