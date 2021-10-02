//
//  DataController.swift
//  HypedList
//
//  Created by ZappyCode on 10/20/20.
//

import Foundation
import SwiftDate
import UIColor_Hex_Swift
import SwiftUI
#if !os(tvOS)
import WidgetKit
#endif

class DataController: ObservableObject {
    static var shared = DataController()
    
    @Published var hypedEvents: [HypedEvent] = []
    @Published var discoverHypedEvents: [HypedEvent] = []
    
    var upcomingHypedEvents: [HypedEvent] {
        return hypedEvents.filter { $0.date > Date().dateAt(.startOfDay) }.sorted { $0.date < $1.date }
    }
    
    var pastHypedEvents: [HypedEvent] {
        return hypedEvents.filter { $0.date < Date().dateAt(.startOfDay) }.sorted { $0.date < $1.date }
    }
    
    func addFromDiscover(hypedEvent: HypedEvent) {
        if(!hypedEvent.hasBeenAdded) {
            hypedEvents.append(hypedEvent)
            hypedEvent.objectWillChange.send()
            saveData()
        }
    }
    
    func deleteHypedEvent(hypedEvent: HypedEvent) {
        if let index = hypedEvents.firstIndex(where: { loopingHypedEvent -> Bool in
            return hypedEvent.id == loopingHypedEvent.id
        }) {
            hypedEvents.remove(at: index)
        }
        saveData()
    }
    
    func saveHypedEvent(hypedEvent: HypedEvent) {
        if let index = hypedEvents.firstIndex(where: { loopingHypedEvent -> Bool in
            return hypedEvent.id == loopingHypedEvent.id
        }) {
            hypedEvents[index] = hypedEvent
        } else {
            hypedEvents.append(hypedEvent)
        }
        saveData()
    }
    
    func saveData() {
        DispatchQueue.global().async {
            if let defaults = UserDefaults(suiteName: "group.com.hypelist") {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(self.hypedEvents) {
                    defaults.setValue(encoded, forKey: "hypedEvents")
                    defaults.synchronize()
                    #if !os(tvOS)
                    WidgetCenter.shared.reloadAllTimelines()
                    #endif
                }
            }
            #if !os(macOS) && !os(tvOS)
            PhoneToWatchDataController.shared.sendContext(context: PhoneToWatchDataController.shared.convertHypedEventsToContext(hypedEvents: self.upcomingHypedEvents))
            #endif
        }
    }
    
    func loadData() {
        DispatchQueue.global().async {
            if let defaults = UserDefaults(suiteName: "group.com.hypelist") {
                if let data = defaults.data(forKey: "hypedEvents") {
                    let decoder = JSONDecoder()
                    if let jsonHypedEvents = try? decoder.decode([HypedEvent].self, from: data) {
                        DispatchQueue.main.async {
                            self.hypedEvents = jsonHypedEvents
                            #if !os(macOS) && !os(tvOS)
                            PhoneToWatchDataController.shared.sendContext(context: PhoneToWatchDataController.shared.convertHypedEventsToContext(hypedEvents: self.upcomingHypedEvents))
                            #endif
                        }
                    }
                }
            }
        }
    }
    
    func getUpcomingForWidget() -> [HypedEvent] {
        if let defaults = UserDefaults(suiteName: "group.com.hypelist") {
            if let data = defaults.data(forKey: "hypedEvents") {
                let decoder = JSONDecoder()
                if let jsonHypedEvents = try? decoder.decode([HypedEvent].self, from: data) {
                    return jsonHypedEvents
                }
            }
        }
        return []
    }
    
    func getDiscoverEvents() {
        if let url = URL(string: "https://api.jsonbin.io/b/5f7e1e0565b18913fc5c408c/latest") {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let webData = data {
                    if let json = try? JSONSerialization.jsonObject(with: webData, options: []) as? [[String:String]] {
                        
                        var hypedEventsToAdd: [HypedEvent] = []
                        
                        for jsonHypedEvent in json {
                            let hypedEvent = HypedEvent()
                            if let id = jsonHypedEvent["id"] {
                                hypedEvent.id = id
                            }
                            if let dateString = jsonHypedEvent["date"] {
                                SwiftDate.defaultRegion = Region.local
                                if let dateInRegion = dateString.toDate() {
                                    hypedEvent.date = dateInRegion.date
                                }
                            }
                            if let title = jsonHypedEvent["title"] {
                                hypedEvent.title = title
                            }
                            if let url = jsonHypedEvent["url"] {
                                hypedEvent.url = url
                            }
                            if let colorHex = jsonHypedEvent["color"] {
                                #if os(macOS)
                                hypedEvent.color = try! Color(NSColor(rgba_throws: "#" + colorHex))
                                #else
                                hypedEvent.color = Color(UIColor("#" + colorHex))
                                #endif
                            }
                            if let imageURL = jsonHypedEvent["imageURL"] {
                                if let url = URL(string: imageURL) {
                                    if let data = try? Data(contentsOf: url) {
                                        hypedEvent.imageData = data
                                    }
                                }
                            }
                            hypedEventsToAdd.append(hypedEvent)
                        }
                        DispatchQueue.main.async {
                            self.discoverHypedEvents = hypedEventsToAdd
                        }
                    }
                }
            }.resume()
        }
    }
}
