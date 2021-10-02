//
//  DiscoverView.swift
//  HypeList (iOS)
//
//  Created by paige on 2021/09/25.
//

import SwiftUI

struct DiscoverView: View {
    
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        HypedEventListView(hypedEvents: data.discoverHypedEvents.sorted { $0.date < $1.date}, noEventsText: "Loading some awesome stuff for ya!", isDiscover: true)
            .navigationTitle("Discover")
            .navigationBarItems(
                trailing: Button(action: {
                    data.getDiscoverEvents()
                }, label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.title)
                })
            )
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
