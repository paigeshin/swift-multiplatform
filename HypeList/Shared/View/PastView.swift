//
//  PastView.swift
//  HypeList (iOS)
//
//  Created by paige on 2021/09/25.
//

import SwiftUI

struct PastView: View {
    
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        HypedEventListView(hypedEvents: data.pastHypedEvents, noEventsText: "No events have passed yet, you should add some more things!")
        .navigationTitle("Past")
    }
}

struct PastView_Previews: PreviewProvider {
    static var previews: some View {
        PastView()
    }
}
