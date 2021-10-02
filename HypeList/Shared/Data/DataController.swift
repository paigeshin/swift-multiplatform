//
//  DataController.swift
//  HypeList
//
//  Created by paige on 2021/09/24.
//

import SwiftUI
import SwiftDate
import UIColor_Hex_Swift
#if !os(watchOS)
import WidgetKit
#endif

class DataController: ObservableObject {
    static var shared = DataController()
    
    var upcomingHypedEvents: [HypedEvent] {
        return hypedEvents.filter { $0.date > Date().dateAt(.startOfDay) }.sorted {$0.date < $1.date}
    }
    var pastHypedEvents: [HypedEvent] {
        return hypedEvents.filter { $0.date < Date().dateAt(.startOfDay) }.sorted {$0.date < $1.date}
    }
    
    @Published var hypedEvents: [HypedEvent] = []
    @Published var discoverHypedEvents: [HypedEvent] = []
    
    
    func addFromDiscover(hypedEvent: HypedEvent) {
        hypedEvents.append(hypedEvent)
        hypedEvent.objectWillChange.send()
        saveData()
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
            if let defaults = UserDefaults(suiteName: "group.com.paige.hypelist") {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(self.hypedEvents) {
                    defaults.setValue(encoded, forKey: "hypedEvents")
                    defaults.synchronize()
                    #if !os(watchOS)
                    WidgetCenter.shared.reloadAllTimelines()
                    #endif
                }
            }

        }
    }
    
    func loadData() {
        DispatchQueue.global().async {
            if let defaults = UserDefaults(suiteName: "group.com.paige.hypelist") {
                if let data = defaults.data(forKey: "hypedEvents") {
                    let decoder = JSONDecoder()
                    if let jsonHypedvents = try? decoder.decode([HypedEvent].self, from: data) {
                        DispatchQueue.main.async {
                            self.hypedEvents = jsonHypedvents
                            // MARK: - SEND DATA TO APPLE WATCH
                            let context = PhoneToWatchDataController.shared.convertHypedEventsToContext(hypedEvents: self.hypedEvents)
                            print("send context to apple watch: \(context)")
                            #if os(iOS)
                            PhoneToWatchDataController.shared.sendContext(context: context)
                            #endif
                        }
                    }
                }
            }
        }
    }
    
    func getUpcomingForWidget() -> [HypedEvent] {
        if let defaults = UserDefaults(suiteName: "group.com.paige.hypelist") {
            if let data = defaults.data(forKey: "hypedEvents") {
                let decoder = JSONDecoder()
                if let jsonHypedvents = try? decoder.decode([HypedEvent].self, from: data) {
                    return jsonHypedvents
                }
            }
        }
        return []
    }
    
    
    func getDiscoverEvents() {
        // https://api.jsonbin.io/b/614f1cd0aa02be1d444e805d
        // https://api.jsonbin.io/b/614f1da4aa02be1d444e80a4
        // https://api.jsonbin.io/b/614f24b9aa02be1d444e82d3
        if let url = URL(string: "https://api.jsonbin.io/b/614f24b9aa02be1d444e82d3") {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let webData = data {
                    if let json = try? JSONSerialization.jsonObject(with: webData, options: []) as? [[String: Any]]{
                        var hypedEventToAdd: [HypedEvent] = []
                        for jsonHypedEvent in json {
                            let hypedEvent = HypedEvent()
                            hypedEvent.id = jsonHypedEvent["id"] as! String
                            if let dateString = jsonHypedEvent["date"] as? String{
                                SwiftDate.defaultRegion = Region.local
                                if let dateInRegion = dateString.toDate() {
                                    hypedEvent.date = dateInRegion.date
                                }
                            }
                            hypedEvent.title = jsonHypedEvent["title"] as! String
                            hypedEvent.url = jsonHypedEvent["url"] as! String
                            if let colorHex = jsonHypedEvent["color"] as? String {
                                #if os(macOS)
                                hypedEvent.color = Color(NSColor("#"+colorHex))
                                #else
                                hypedEvent.color = Color(UIColor("#"+colorHex))
                                #endif
                            }
                            if let imageURL = jsonHypedEvent["imageURL"] as? String {
                                if let url = URL(string: imageURL) {
                                    if let data = try? Data(contentsOf: url) {
                                        hypedEvent.imageData = data
                                    }
                                }
                            }
                            hypedEventToAdd.append(hypedEvent)
                        }
                        DispatchQueue.main.async {
                            self.discoverHypedEvents = hypedEventToAdd
                        }
                    }
                }
            }
            .resume()
        }
    }
    
}
