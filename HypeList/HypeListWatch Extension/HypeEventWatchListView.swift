//
//  HypedEventWatchListView.swift
//  HypedListWatch Extension
//
//  Created by ZappyCode on 10/21/20.
//

import SwiftUI

struct HypedEventWatchListView: View {
    
    var hypedEvents: [HypedEvent]
    
    var body: some View {
        if hypedEvents.count > 0 {
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(hypedEvents) { hypedEvent in
                        HStack {
                            Spacer()
                            VStack {
                                
                                Text(hypedEvent.title)
                                    .font(.headline)
                                    
                                Text("\(hypedEvent.timeFromNow().capitalized) on \(hypedEvent.dateAsString())")
                            }
                            .foregroundColor(hypedEvent.color.isDarkColor ? .white : .black)
                            .multilineTextAlignment(.center)
                            .padding(5)
                            Spacer()
                        }
                        .background(hypedEvent.color)
                        .cornerRadius(5)
                    }
                }
            }
            
        } else {
            Text("Nothing to look forward to 😕 Go to your phone app and add some stuff 🥳")
                .multilineTextAlignment(.center)
        }
    }
}

struct HypedEventWatchListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HypedEventWatchListView(hypedEvents: [testHypedEvent1, testHypedEvent2])
            
            HypedEventWatchListView(hypedEvents: [])
        }
    }
}

extension Color {
    var isDarkColor: Bool {
        var r, g, b, a: CGFloat
        (r,g,b,a) = (0,0,0,0)
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return lum < 0.6
    }
}
