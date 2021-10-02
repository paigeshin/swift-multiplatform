//
//  PhoneToWatchDataController.swift
//  HypedListiOS
//
//  Created by ZappyCode on 10/21/20.
//

import Foundation
import WatchConnectivity

class PhoneToWatchDataController: NSObject, WCSessionDelegate {
    
    static var shared = PhoneToWatchDataController()
    var session: WCSession?
    
    func setupSession() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        switch activationState {
        case .activated:
            print("Activated!")
        default:
            print("Not able to talk to watch :(")
        }
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Now Inaactive :(")
    }
    #endif
    
    #if os(iOS)
    func sessionDidDeactivate(_ session: WCSession) {
        print("Did Deactivate :(")
    }
    #endif
    
    // send manually json data 
    func sendContext(context: [String:Any]) {
        print("send context! \(context)")
        try! session!.updateApplicationContext(context)
    }
    
    
    func convertHypedEventsToContext(hypedEvents: [HypedEvent]) -> [String:Any] {
        var imagelessHypedEvents: [HypedEvent] = []
        for hypedEvent in hypedEvents {
            let imagelessHypedEvent = HypedEvent()
            imagelessHypedEvent.id = hypedEvent.id
            imagelessHypedEvent.date = hypedEvent.date
            imagelessHypedEvent.title = hypedEvent.title
            imagelessHypedEvent.color = hypedEvent.color
            imagelessHypedEvent.url = hypedEvent.url
            imagelessHypedEvents.append(imagelessHypedEvent)
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(imagelessHypedEvents) {
            return ["hypedEvents":encoded]
        }
        return ["failed":0]
    }
    
    // When received data, send back json data
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if let defaults = UserDefaults(suiteName: "group.com.paige.hypelist") {
            if let data = defaults.data(forKey: "hypedEvents") {
                let decoder = JSONDecoder()
                if let jsonHypedEvents = try? decoder.decode([HypedEvent].self, from: data) {
                    DispatchQueue.main.async {
                        replyHandler(self.convertHypedEventsToContext(hypedEvents: jsonHypedEvents))
                    }
                }
            }
        }
        
    }
}
