//
//  MainView.swift
//  HypeList (iOS)
//
//  Created by paige on 2021/09/26.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        // iPhone
        if horizontalSizeClass == .compact {
            HypedListTabView()
        } else {
            // iPad
            HypedListSidebarView()
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
