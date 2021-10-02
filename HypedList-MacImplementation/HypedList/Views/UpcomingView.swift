//
//  UpcomingView.swift
//  HypedList
//
//  Created by ZappyCode on 10/17/20.
//

import SwiftUI

struct UpcomingView: View {
    
    @State var showingCreateView = false
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        #if os(macOS)
        HypedEventListView(hypedEvents: data.upcomingHypedEvents, noEventsText: "Nothing to look forward to 😥\nCreate an event or check out the Discover tab!")
        .navigationTitle("Upcoming")
        #else
        HypedEventListView(hypedEvents: data.upcomingHypedEvents, noEventsText: "Nothing to look forward to 😥\nCreate an event or check out the Discover tab!")
        .navigationTitle("Upcoming")
        .navigationBarItems(trailing:
                                Button(action: {
                                    showingCreateView = true
                                }) {
                                    Image(systemName: "calendar.badge.plus")
                                        .font(.title)
                                }
            .sheet(isPresented: $showingCreateView) {
                CreateHypedEventView()
            }
        )
        #endif
    }
}

struct UpcomingView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingView()
    }
}
