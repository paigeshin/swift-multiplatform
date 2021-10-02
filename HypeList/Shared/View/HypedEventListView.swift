//
//  HypedEventListView.swift
//  HypeList (iOS)
//
//  Created by paige on 2021/09/25.
//

import SwiftUI

struct HypedEventListView: View {
    
    var hypedEvents: [HypedEvent]
    var noEventsText: String
    var isDiscover = false
    
    var body: some View {
        ScrollView {
            VStack {
                if hypedEvents.count == 0 {
                    Text(noEventsText)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.top, 50)
                        .padding(.horizontal, 20)
                    
                } else {
                    ForEach(hypedEvents, id: \.id) { hypedEvent in
                        NavigationLink(
                            destination: HypedEventDetailView(hypedEvent: hypedEvent, isDiscover: isDiscover),
                            label: {
                                HypedEventTileView(hypedEvent: hypedEvent)
                            })
                            .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}

struct HypedEventListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HypedEventListView(hypedEvents: [testHypedEvent1, testHypedEvent2], noEventsText: "Nothing here :(")
        }
    }
}
