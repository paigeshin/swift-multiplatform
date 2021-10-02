//
//  ContentView.swift
//  HypedListTV
//
//  Created by paige on 2021/10/02.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        TabView {
            HypedEventTVListView(hypedEvents: data.upcomingHypedEvents, noEventsText: "Nothing to look forward to \nCreate an event")
                .tabItem {
                    Image(systemName:"calendar")
                    Text("Upcoming")
                }
            HypedEventTVListView(hypedEvents: data.discoverHypedEvents, noEventsText: "Loading some awesome sutff")
                .tabItem {
                    Image(systemName:"magnifyingglass")
                    Text("Discover")
                }
            HypedEventTVListView(hypedEvents: data.pastHypedEvents, noEventsText: "Nothing to show")
                .tabItem {
                    Image(systemName:"gobackward")
                    Text("Past")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
