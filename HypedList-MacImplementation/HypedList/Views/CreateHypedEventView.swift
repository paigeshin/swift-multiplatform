//
//  CreateHypedEventView.swift
//  HypedList
//
//  Created by ZappyCode on 10/17/20.
//

import SwiftUI

struct CreateHypedEventView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var hypedEvent = HypedEvent()
    @State var showTime = false
    @State var showImagePicker = false
    
    var body: some View {
        #if os(macOS)
        bodyMac
        #else
        bodyNotMac
        #endif
    }
    
    var bodyMac: some View {
        VStack {
            VStack(alignment: .leading) {
                Form {
                    Section {
                        FormLabelView(title: "Title", iconSystemName: "keyboard", color: .green)
                        TextField("Family Vacation", text: $hypedEvent.title)
                            .padding(.bottom, 20)
                    }
                     
                    
                    Section {
                        FormLabelView(title: "Date", iconSystemName: "calendar", color: .blue)
                        DatePicker("", selection: $hypedEvent.date, displayedComponents: [.date, .hourAndMinute])
                            .padding(.bottom, 20)
                    }
                    
                    Section {
                        FormLabelView(title: "", iconSystemName: "eyedropper", color: .yellow)
                            .padding(.bottom, 1)
                            
                        ColorPicker(selection: $hypedEvent.color) {}
                            .frame(height: 30)
                            .padding(.bottom, 20)
                    }
                    
                    Section {
                        FormLabelView(title: "URL", iconSystemName: "link", color: .orange)
                        TextField("nintendo.com", text: $hypedEvent.url)
                    }
                }
            }
            .padding()
            Spacer()
            Divider()
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                })
                Button(action: {
                    DataController.shared.saveHypedEvent(hypedEvent: hypedEvent)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Done")
                })
                .keyboardShortcut(.defaultAction)
            }
            .padding()
        }
        .frame(minWidth: 400, minHeight: 400)

    }
    
    #if !os(macOS)
    var bodyNotMac: some View {
        NavigationView {
            Form {
                
                Section {
                    FormLabelView(title: "Title", iconSystemName: "keyboard", color: .green)
                    TextField("Family Vacation", text: $hypedEvent.title)
                        .autocapitalization(.words)
                }
                
                Section {
                    FormLabelView(title: "Date", iconSystemName: "calendar", color: .blue)
                    DatePicker("Date", selection: $hypedEvent.date, displayedComponents: showTime ? [.date, .hourAndMinute] : [.date])
                        .datePickerStyle(GraphicalDatePickerStyle())
                    Toggle(isOn: $showTime) {
                        FormLabelView(title: "Time", iconSystemName: "clock.fill", color: .blue)
                    }
                }
                
                
                Section {
                    if hypedEvent.image() == nil {
                        HStack {
                            FormLabelView(title: "Image", iconSystemName: "camera", color: .purple)
                            
                            Spacer()
                            
                            Button(action: {
                                showImagePicker = true
                            }) {
                                Text("Pick Image")
                            }
                        }
                    } else {
                        HStack {
                            FormLabelView(title: "Image", iconSystemName: "camera", color: .purple)
                            
                            Spacer()
                            
                            Button(action: {
                                hypedEvent.imageData = nil
                            }) {
                                Text("Remove Image")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        Button(action: {
                            showImagePicker = true
                        }) {
                            hypedEvent.image()!
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(imageData: $hypedEvent.imageData)
                }
                
                
                
                Section {
                    
                    ColorPicker(selection: $hypedEvent.color) {
                        FormLabelView(title: "Color", iconSystemName: "eyedropper", color: .yellow)
                    }
                }
                
                Section {
                    FormLabelView(title: "URL", iconSystemName: "link", color: .orange)
                    TextField("nintendo.com", text: $hypedEvent.url)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                }
            }
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
                    .font(.title2)
            }, trailing: Button(action: {
                DataController.shared.saveHypedEvent(hypedEvent: hypedEvent)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
                    .font(.title2)
                    .bold()
            })
            .navigationTitle("Create")
        }
    }
    #endif
    
}





struct CreateHypedEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateHypedEventView()
            .previewLayout(.fixed(width: 400, height: 380))
    }
}
