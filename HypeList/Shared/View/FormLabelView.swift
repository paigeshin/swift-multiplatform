//
//  FormLabelView.swift
//  HypeList
//
//  Created by paige on 2021/09/22.
//

import SwiftUI

struct FormLabelView: View {
    
    var title: String
    var iconSystemName: String
    var color: Color
    
    var body: some View {
        Label {
            Text(title)
        } icon: {
            Image(systemName: iconSystemName)
                .padding(4)
                .background(color)
                .cornerRadius(7)
                .foregroundColor(.white)
        }
    }
}

struct FormLabelView_Previews: PreviewProvider {
    static var previews: some View {
        FormLabelView(title: "title", iconSystemName: "keyboard", color: Color.white)
    }
}
