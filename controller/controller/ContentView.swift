//
//  ContentView.swift
//  controller
//
//  Created by paige on 2021/09/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var sliderValue = 0.0
    @State var text = ""
    
    var body: some View {
        VStack {
            Slider(value: $sliderValue)
            Text("Slider is: \(sliderValue)")
            TextField("hi", text: $text)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
