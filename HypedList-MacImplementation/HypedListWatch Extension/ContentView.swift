//
//  ContentView.swift
//  HypedListWatch Extension
//
//  Created by ZappyCode on 10/21/20.
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
