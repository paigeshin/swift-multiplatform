//
//  HypedEventListView.swift
//  HypedList
//
//  Created by ZappyCode on 10/20/20.
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
                    ForEach(hypedEvents) { hypedEvent in
                        NavigationLink(
                            destination: HypedEventDetailView(hypedEvent: hypedEvent, isDiscover: isDiscover)) {
                            HypedEventTileView(hypedEvent: hypedEvent)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .frame(minWidth: 250)
    }
}

struct HypedEventListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HypedEventListView(hypedEvents: [testHypedEvent1,testHypedEvent2], noEventsText: "Nothing here :(")
            
            HypedEventListView(hypedEvents: [], noEventsText: "Nothing here :(")
        }
    }
}
