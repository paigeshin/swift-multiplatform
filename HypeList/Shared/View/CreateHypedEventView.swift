//
//  CreateHypedEventView.swift
//  HypeList
//
//  Created by paige on 2021/09/22.
//

import SwiftUI

struct CreateHypedEventView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var hypedEvent: HypedEvent = HypedEvent()
    @State var showTime = false
    
    @State var showImagePicker = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    FormLabelView(title: "Title", iconSystemName: "keyboard", color: .green)
                    TextField("Family Vacation", text: $hypedEvent.title)
                        .autocapitalization(.words)
                }
                Section {
                    FormLabelView(title: "Date", iconSystemName: "calendar", color: .blue)
                    DatePicker("Date",
                               selection: $hypedEvent.date,
                               displayedComponents:
                                showTime ? [.date, .hourAndMinute] : [.date]
                    )
                    .datePickerStyle(GraphicalDatePickerStyle())
                    Toggle(isOn: $showTime, label: {
                        FormLabelView(title: "Time", iconSystemName: "clock.fill", color: .blue)
                    })
                }
                
                Section {
                    if hypedEvent.image() == nil {
                        HStack {
                            FormLabelView(title: "Image", iconSystemName: "camera", color: .purple)
                            
                            Spacer()
                            
                            Button(action: {
                                showImagePicker = true
                            }, label: {
                                Text("Pick Image")
                            })
                        }
                    } else {
                        HStack {
                            FormLabelView(title: "Image", iconSystemName: "camera", color: .purple)
                            
                            Spacer()
                            
                            Button(action: {
                                hypedEvent.imageData = nil
                            }, label: {
                                Text("Remove Image")
                                    .foregroundColor(.red)
                            })
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        Button(action: {
                            showImagePicker = true
                        }, label: {
                            hypedEvent.image()!
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        })
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
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                        .font(.title2)
                }), trailing: Button(action: {
                    DataController.shared.saveHypedEvent(hypedEvent: hypedEvent)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Done")
                        .font(.title2)
                        .bold()
                }))
            .navigationTitle("Create")
        }

    }
}

struct CreateHypedEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateHypedEventView()
    }
}
