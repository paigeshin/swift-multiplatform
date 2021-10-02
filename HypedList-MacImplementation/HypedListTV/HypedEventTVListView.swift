//
//  HypedEventTVListView.swift
//  HypedListTV
//
//  Created by paige on 2021/10/02.
//

import SwiftUI

struct HypedEventTVListView: View {
    var hypedEvents: [HypedEvent]
    var noEventsText: String
    var isDiscover = false
    
    var body: some View {
        if hypedEvents.count == 0 {
            Text(noEventsText)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top, 50)
                .padding(.horizontal, 20)
        } else {
            ScrollView(.horizontal) {
                
                HStack {
                    ForEach(hypedEvents) { hypedEvent in
                        Button(action: {
                            
                        }, label: {
                            HypedEventTVTileView(hypedEvent: hypedEvent)
                        })
                        .buttonStyle(PlainButtonStyle())
                        //TVOS
                        .contextMenu(menuItems: {
                            if isDiscover {
                                Button(action: {
                                    DataController.shared.addFromDiscover(hypedEvent: hypedEvent)
                                }, label: {
                                    Text("Add")
                                })
                            } else {
                                Button(action: {
                                    DataController.shared.deleteHypedEvent(hypedEvent: hypedEvent)
                                }, label: {
                                    Text("Delete")
                                })
                            }
                        })
                    }
                }
                
            }
            
        }
    }
    
}
struct HypedEventTVListView_Previews: PreviewProvider {
    static var previews: some View {
        HypedEventTVListView(hypedEvents: [testHypedEvent1, testHypedEvent2], noEventsText: "")
    }
}
