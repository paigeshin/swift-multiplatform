//
//  UpcomingView.swift
//  HypeList
//
//  Created by paige on 2021/09/22.
//

import SwiftUI

struct UpcomingView: View {
    
    @State var showingCreateView = false
    @ObservedObject var data = DataController.shared
    
    
    var body: some View {
        HypedEventListView(hypedEvents: data.hypedEvents, noEventsText: "Nothing to look forward to 🥲\nCreate an event or check out the Discover tab!")
        .navigationTitle("Upcoming")
        .navigationBarItems(
            trailing: Button(action: {
                showingCreateView = true
            }, label: {
                Image(systemName: "calendar.badge.plus")
                    .font(.title)
            })
            .sheet(isPresented: $showingCreateView, content: {
                CreateHypedEventView()
            })
        )
    }
    
}

struct UpcomingView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingView()
    }
}
