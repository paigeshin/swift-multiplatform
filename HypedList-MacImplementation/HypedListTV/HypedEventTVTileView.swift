//
//  HypedEventTVTileView.swift
//  HypedListTV
//
//  Created by paige on 2021/10/02.
//

import SwiftUI

struct HypedEventTVTileView: View {
    
    @ObservedObject var hypedEvent: HypedEvent
    var isDiscover = false
    
    var body: some View {
        VStack(spacing: 0) {
            if hypedEvent.image() != nil {
                HStack {
                    Spacer()
                    hypedEvent.image()!
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Spacer()
                }.background(hypedEvent.color)
            } else {
                hypedEvent.color
                    .aspectRatio(contentMode: .fit)
            }
            Text(hypedEvent.title)
                .font(.largeTitle)
                .padding(.top,10)
                .padding(.horizontal, 10)
                .foregroundColor(.black)
            
            Text("\(hypedEvent.timeFromNow().capitalized) on \(hypedEvent.dateAsString())")
                .font(.title)
                .padding(.bottom,10)
                .padding(.horizontal, 10)
                .foregroundColor(.black)
            
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct HypedEventTVTileView_Previews: PreviewProvider {
    static var previews: some View {
        HypedEventTVTileView(hypedEvent: testHypedEvent1)
    }
}
