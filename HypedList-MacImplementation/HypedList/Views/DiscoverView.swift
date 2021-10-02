//
//  DiscoverView.swift
//  HypedList
//
//  Created by ZappyCode on 10/20/20.
//

import SwiftUI

struct DiscoverView: View {
    
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        #if os(macOS)
        HypedEventListView(hypedEvents: data.discoverHypedEvents.sorted { $0.date < $1.date }, noEventsText: "Loading some awesome stuff for ya!", isDiscover: true)
            .navigationTitle("Discover")
        #else
        HypedEventListView(hypedEvents: data.discoverHypedEvents.sorted { $0.date < $1.date }, noEventsText: "Loading some awesome stuff for ya!", isDiscover: true)
            .navigationTitle("Discover")
            .navigationBarItems(trailing:
                                    Button(action: {
                                        data.getDiscoverEvents()
                                    }) {
                                        Image(systemName: "arrow.clockwise")
                                            .font(.title)
                                    }
            )
        #endif
        
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
