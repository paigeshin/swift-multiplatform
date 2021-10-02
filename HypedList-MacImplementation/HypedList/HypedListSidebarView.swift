//
//  HypedListSidebarView.swift
//  HypedListiOS
//
//  Created by ZappyCode on 10/21/20.
//

import SwiftUI

struct HypedListSidebarView: View {
    
    @State var showingCreateView = false
    
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
            Button(action: {
                showingCreateView = true
            }) {
                Label("Create Event", systemImage: "calendar.badge.plus")
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, 5)
            .foregroundColor(.blue)
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
