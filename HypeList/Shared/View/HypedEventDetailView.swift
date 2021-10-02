//
//  HypedEventDetailView.swift
//  HypeList (iOS)
//
//  Created by paige on 2021/09/25.
//

import SwiftUI

struct HypedEventDetailView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ObservedObject var hypedEvent: HypedEvent
    @State var showingCreateView = false
    var isDiscover = false
    @State var isDeleted = false
    
    var body: some View {
        if isDeleted {
            Text("Select an Event")
        } else {
            if horizontalSizeClass == .compact {
                compact
            } else {
                regular
            }
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
                    .padding(.top, 10)
                    .padding(.horizontal, 10)
                
                Text("\(hypedEvent.timeFromNow().capitalized) on \(hypedEvent.dateAsString())")
                    .font(.title)
                    .padding(.bottom, 10)
                    .padding(.horizontal, 10)
                
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            
            HStack {
                if hypedEvent.validURL() != nil {
                    Button(action: {
                        UIApplication.shared.open(hypedEvent.validURL()!)
                    }, label: {
                        HypedEventDatilViewButtonCompact(backgroundColor: .orange, imageName: "link", text: "Visit Site")
                    })
                }
                
                if isDiscover {
                    Button(action: {
                        DataController.shared.addFromDiscover(hypedEvent: hypedEvent)
                    }, label: {
                        HypedEventDatilViewButtonCompact(backgroundColor: .blue, imageName: "plus.circle", text: hypedEvent.hasBeenAdded ? "Added" : "Add")
                    })
                    .disabled(hypedEvent.hasBeenAdded)
                    .opacity(hypedEvent.hasBeenAdded ? 0.5 : 1.0)
                } else {
                    Button(action: {
                        showingCreateView = true
                    }, label: {
                        HypedEventDatilViewButtonCompact(backgroundColor: .yellow, imageName: "pencil.circle", text: "Edit")
                    })
                    .sheet(isPresented: $showingCreateView) {
                        CreateHypedEventView(hypedEvent: hypedEvent)
                    }
                    
                    Button(action: {
                        DataController.shared.deleteHypedEvent(hypedEvent: hypedEvent)
                        isDeleted = true
                    }, label: {
                        HypedEventDatilViewButtonCompact(backgroundColor: .red, imageName: "trash", text: "Delete")
                    })
                }
            }
            .padding(.top, 15)
        }
        .padding(40)
    }
    
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
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.red)
                Text(hypedEvent.dateAsString())
                Spacer()
            }
            .background(Color.white)
            
            Text("\(hypedEvent.timeFromNow().capitalized) on \(hypedEvent.dateAsString())")
                .font(.title2)
            
            Spacer()
            
            if hypedEvent.validURL() != nil {
                Button(action: {
                    UIApplication.shared.open(hypedEvent.validURL()!)
                }, label: {
                    HypedEventDatilViewButton(backgroundColor: .orange, imageName: "link", text: "Visit Site")
                })
            }
            
            if isDiscover {
                Button(action: {
                    DataController.shared.addFromDiscover(hypedEvent: hypedEvent)
                }, label: {
                    HypedEventDatilViewButton(backgroundColor: .blue, imageName: "plus.circle", text: hypedEvent.hasBeenAdded ? "Added" : "Add")
                })
                .disabled(hypedEvent.hasBeenAdded)
                .opacity(hypedEvent.hasBeenAdded ? 0.5 : 1.0)
            } else {
                Button(action: {
                    showingCreateView = true
                }, label: {
                    HypedEventDatilViewButton(backgroundColor: .yellow, imageName: "pencil.circle", text: "Edit")
                })
                .sheet(isPresented: $showingCreateView) {
                    CreateHypedEventView(hypedEvent: hypedEvent)
                }
                
                Button(action: {
                    DataController.shared.deleteHypedEvent(hypedEvent: hypedEvent)
                    isDeleted = true
                }, label: {
                    HypedEventDatilViewButton(backgroundColor: .red, imageName: "trash", text: "Delete")
                })
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

struct HypedEventDatilViewButton: View {
    
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

struct HypedEventDatilViewButtonCompact: View {
    
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
        .padding(.bottom, 10)
    }
}

struct HypedEventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HypedEventDetailView(hypedEvent: testHypedEvent1)
        }
    }
}
