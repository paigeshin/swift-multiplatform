//
//  HypedEventDetailView.swift
//  HypedList
//
//  Created by ZappyCode on 10/20/20.
//

import SwiftUI

struct HypedEventDetailView: View {
    #if !os(macOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    #endif
    @ObservedObject var hypedEvent: HypedEvent
    @State var showingCreateView = false
    @State var deleted = false
    var isDiscover = false
    
    var body: some View {
        if deleted {
            Text("Select an Event")
        } else {
            #if !os(macOS)
            if horizontalSizeClass == .compact {
                compact
            } else {
                regular
            }
            #else
            regular
            #endif
        }
    }
    
    var regular: some View {
        VStack {
            VStack(spacing: 0) {
                if hypedEvent.image() != nil {
                    hypedEvent.image()!
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    hypedEvent.color
                        .aspectRatio(contentMode: .fit)
                }
                
                
                Text(hypedEvent.title)
                    .font(.largeTitle)
                    .padding(.top,10)
                    .padding(.horizontal, 10)
                
                Text("\(hypedEvent.timeFromNow().capitalized) on \(hypedEvent.dateAsString())")
                    .font(.title)
                    .padding(.bottom,10)
                    .padding(.horizontal, 10)
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            
            
            HStack {
                if hypedEvent.validURL() != nil {
                    Button(action: {
                        #if os(macOS)
                        NSWorkspace.shared.open(hypedEvent.validURL()!)
                        #else
                        UIApplication.shared.open(hypedEvent.validURL()!)
                        #endif
                    }) {
                        HypedEventDetailViewButtonCompact(backgroundColor: .orange, imageName: "link", text: "Visit Site")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                if isDiscover {
                    Button(action: {
                        DataController.shared.addFromDiscover(hypedEvent: hypedEvent)
                    }) {
                        HypedEventDetailViewButtonCompact(backgroundColor: .blue, imageName: "plus.circle", text: hypedEvent.hasBeenAdded ? "Added" : "Add")
                    }
                    .disabled(hypedEvent.hasBeenAdded)
                    .opacity(hypedEvent.hasBeenAdded ? 0.5 : 1.0)
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Button(action: {
                        showingCreateView = true
                    }) {
                        HypedEventDetailViewButtonCompact(backgroundColor: .yellow, imageName: "pencil.circle", text: "Edit")
                    }
                    .sheet(isPresented: $showingCreateView) {
                        CreateHypedEventView(hypedEvent: hypedEvent)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        DataController.shared.deleteHypedEvent(hypedEvent: hypedEvent)
                        deleted = true
                    }) {
                        HypedEventDetailViewButtonCompact(backgroundColor: .red, imageName: "trash", text: "Delete")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.top, 15)
        }
        .padding(40)
    }
    
    #if !os(macOS)
    var compact: some View {
        VStack(spacing: 0) {
            if hypedEvent.image() != nil {
                hypedEvent.image()!
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            Rectangle()
                .foregroundColor(hypedEvent.color)
                .frame(height: 15)
            
            HStack {
                Text(hypedEvent.title)
                    .font(.title)
                    .padding(10)
                Spacer()
            }
            .background(Color.white)
            
            Text("\(hypedEvent.timeFromNow().capitalized) on \(hypedEvent.dateAsString())").font(.title2)
            
            Spacer()
            
            if hypedEvent.validURL() != nil {
                Button(action: {
                    #if os(macOS)
                    NSWorkspace.shared.open(hypedEvent.validURL()!)
                    #else
                    UIApplication.shared.open(hypedEvent.validURL()!)
                    #endif
                }) {
                    HypedEventDetailViewButton(backgroundColor: .orange, imageName: "link", text: "Visit Site")
                }
            }
            
            if isDiscover {
                Button(action: {
                    DataController.shared.addFromDiscover(hypedEvent: hypedEvent)
                }) {
                    HypedEventDetailViewButton(backgroundColor: .blue, imageName: "plus.circle", text: hypedEvent.hasBeenAdded ? "Added" : "Add")
                }
                .disabled(hypedEvent.hasBeenAdded)
                .opacity(hypedEvent.hasBeenAdded ? 0.5 : 1.0)
            } else {
                Button(action: {
                    showingCreateView = true
                }) {
                    HypedEventDetailViewButton(backgroundColor: .yellow, imageName: "pencil.circle", text: "Edit")
                }
                .sheet(isPresented: $showingCreateView) {
                    CreateHypedEventView(hypedEvent: hypedEvent)
                }
                
                Button(action: {
                    DataController.shared.deleteHypedEvent(hypedEvent: hypedEvent)
                    deleted = true
                }) {
                    HypedEventDetailViewButton(backgroundColor: .red, imageName: "trash", text: "Delete")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    #endif
}

struct HypedEventDetailViewButton: View {
    
    var backgroundColor: Color
    var imageName: String
    var text: String
    
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: imageName)
            Text(text)
            Spacer()
        }
        .font(.title2)
        .padding(12)
        .background(backgroundColor)
        .foregroundColor(.white)
        .cornerRadius(5)
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct HypedEventDetailViewButtonCompact: View {
    
    var backgroundColor: Color
    var imageName: String
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
            Text(text)
        }
        .font(.title2)
        .padding(12)
        .background(backgroundColor)
        .foregroundColor(.white)
        .cornerRadius(5)
        
    }
}

struct HypedEventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            HypedEventDetailView(hypedEvent: testHypedEvent1)
            HypedEventDetailView(hypedEvent: testHypedEvent2)
            HypedEventDetailViewButton(backgroundColor: .orange, imageName: "link", text: "Visit Site")
            HypedEventDetailViewButtonCompact(backgroundColor: .orange, imageName: "link", text: "Visit Site")
        }
    }
}
