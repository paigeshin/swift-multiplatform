//
//  MainView.swift
//  HypedListiOS
//
//  Created by ZappyCode on 10/21/20.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        if horizontalSizeClass == .compact {
            HypedListTabView()
        } else {
            HypedListSidebarView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
