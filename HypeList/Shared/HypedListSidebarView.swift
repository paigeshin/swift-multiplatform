//
//  HypedListSizebarView.swift
//  HypeList (iOS)
//
//  Created by paige on 2021/09/26.
//

import SwiftUI

struct HypedListSidebarView: View {
    
    @State var showingCreateView: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: UpcomingView()) {
                    Label("Upcoming", systemImage: "calendar")
                }
                NavigationLink(destination: DiscoverView()) {
                    Label("Discover", systemImage: "magnifyingglass")
                }
                NavigationLink(destination: PastView()) {
                    Label("Past", systemImage: "gobackward")
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("HypedList")
            .overlay(bottomSidebarView, alignment: .bottom)
            
            UpcomingView()
            
            Text("Select an Event")
            
        }
    }
    
    var bottomSidebarView: some View {
        VStack {
            Divider()
            Button {
                showingCreateView = true 
            } label: {
                Label("Create Event", systemImage: "calendar.badge.plus")
            }
            .sheet(isPresented: $showingCreateView) {
                CreateHypedEventView()
            }
        }
    }
}

struct HypedListSidebarView_Previews: PreviewProvider {
    static var previews: some View {
        HypedListSidebarView()
    }
}
