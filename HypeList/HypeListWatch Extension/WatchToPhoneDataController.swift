//
//  WatchToPhoneDataController.swift
//  HypedListWatch Extension
//
//  Created by ZappyCode on 10/21/20.
//

import Foundation
import WatchConnectivity

class WatchToPhoneDataController: NSObject, WCSessionDelegate, ObservableObject {
    static var shared = WatchToPhoneDataController()
    
    @Published var hypedEvents: [HypedEvent] = []
    
    var session = WCSession.default
    
    override init() {
        super.init()
        
        session.delegate = self
        session.activate()
        
        DispatchQueue.global().async {
            if let data = UserDefaults.standard.data(forKey: "hypedEvents") {
                    let decoder = JSONDecoder()
                    if let jsonHypedEvents = try? decoder.decode([HypedEvent].self, from: data) {
                        DispatchQueue.main.async {
                            self.hypedEvents = jsonHypedEvents
                        }
                    }
                }
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        switch activationState {
        case .activated:
            print("Activated!")
            // send message
            sendMessage()
        default:
            print("Not able to talk to watch :(")
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        decodeContext(context: applicationContext)
    }
    
    func decodeContext(context: [String:Any]) {
        if let hypedData = context["hypedEvents"] as? Data {
            let decoder = JSONDecoder()
            if let hypedEventsJSON = try? decoder.decode([HypedEvent].self, from: hypedData) {
                DispatchQueue.main.async {
                    self.hypedEvents = hypedEventsJSON
                    DispatchQueue.global().async {
                            let encoder = JSONEncoder()
                            if let encoded = try? encoder.encode(self.hypedEvents) {
                                UserDefaults.standard.setValue(encoded, forKey: "hypedEvents")
                                UserDefaults.standard.synchronize()
                            }
                    }
                }
            }
        }
    }
    
    // send message
    func sendMessage() {
        session.sendMessage(["I want":"Data"]) { (context) in
            self.decodeContext(context: context)
        } errorHandler: { (error) in
            print(error)
        }

    }
}

