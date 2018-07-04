//
//  InstachkService.swift
//  AdViewApp
//
//  Created by Naresh on 6/7/18.
//  Copyright © 2018 Instachk. All rights reserved.
//

import UIKit
import Starscream
import CoreLocation

class InstachkService : NSObject {
    
    // Google Cloud endpoints
    let WS_SERVER_ENDPOINT = "ws://prod.instachk.today"
    let HTTP_SERVER_ENDPOINT = "http://prod.instachk.today/api/v1/users/"
    
    var socket : WebSocketClient
    var apiKey : String!
    var partnerKey : String
    var lastLocation : CLLocation?
    var lastUpdatedLocation : CLLocation?
    var connected : Bool
    var delegate : MessageListener?
    var locationManager: CLLocationManager?
    
    init(partnerKey : String) {
        self.connected = false
        self.partnerKey = partnerKey
        self.socket = WebSocket(url: URL(string: self.WS_SERVER_ENDPOINT + "/cable")!)
        super.init()
        self.socket.delegate = self
    }
    
    func initialize() {
        let settings = UserDefaults.standard
        let storedAPIKey = settings.string(forKey: "apiKey")
        if (storedAPIKey == nil) {
            self.registerAndInitializeAPIKey(settings: settings);
        } else {
            self.apiKey = storedAPIKey!
            self.connectWebSocket()
        }
    }
    
    private func registerAndInitializeAPIKey(settings : UserDefaults) {
        let iosId = UIDevice.current.identifierForVendor!.uuidString
        let deviceId = "AF4B2INST" + iosId;
        
        do {
            //prepare the request
            let jsonMap: [String: Any] = [
                "device_id": deviceId,
                "email": deviceId + "@instachk.today"]
            
            let requestURL = URL(string: self.HTTP_SERVER_ENDPOINT + "register")!
            var urlRequest = URLRequest(url: requestURL)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            // adding package name
            urlRequest.setValue(Bundle.main.bundleIdentifier!, forHTTPHeaderField: "Package-Name")
            
            // adding api key
            urlRequest.setValue("Token token=\(self.apiKey ?? "null")::\(self.partnerKey)", forHTTPHeaderField: "Authorization")
            
            // TODO - remove print
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: jsonMap, options: [])
            let session = URLSession.shared
            
            let task = session.dataTask(with: urlRequest) { data, response, error in
                
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: data!, options: [])
                            as? [String: Any]
                            else {
                                print("Could not get JSON from responseData as dictionary")
                                return
                        }
                        
                        let fetchedAPIKey = json["api_key"]
                        settings.setValue(fetchedAPIKey, forKey: "apiKey")
                        settings.synchronize()
                        self.apiKey = fetchedAPIKey as! String
                        self.connectWebSocket()
                    } catch {
                        print("Could not get JSON from responseData as dictionary")
                    }
                } else  {
                    print("Failed registering user")
                }
          }
         task.resume()
        } catch {
            print("Failed registering user")
        }
    }
    
    // TODO - move headers to a single function
    public func activateCoupon(advertisement_id: Int) {
        do {
            //prepare the request
            let jsonMap: [String: Any] = ["advertisement_id": advertisement_id]
            
            let requestURL = URL(string: self.HTTP_SERVER_ENDPOINT + "activate-coupon")!
            var urlRequest = URLRequest(url: requestURL)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            // adding package name
            urlRequest.setValue(Bundle.main.bundleIdentifier!, forHTTPHeaderField: "Package-Name")
            
            // adding api key
            urlRequest.setValue("Token token=\(self.apiKey ?? "null")::\(self.partnerKey)", forHTTPHeaderField: "Authorization")
            
            // TODO - remove print
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: jsonMap, options: [])
            let session = URLSession.shared
            
            let task = session.dataTask(with: urlRequest) { data, response, error in
                
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: data!, options: [])
                            as? [String: Any]   else {
                           return
                        }
                        
                        if  let error = json["error"] as? String {
                            print("\(error)")
                        } else {
                            self.delegate!.onCouponActivated!(advertisement_id: advertisement_id)
                        }
                    } catch {
                        print("Could not get JSON from responseData as dictionary")
                    }
                } else  {
                    print("Failed activate coupon")
                }
             }
          task.resume()
        } catch {
            print("Failed registering user")
        }
    }
    
    private func connectWebSocket() {
        let requestURL = URL(string: self.HTTP_SERVER_ENDPOINT + "activate-coupon")!
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        // adding package name
        urlRequest.setValue(Bundle.main.bundleIdentifier!, forHTTPHeaderField: "Package-Name")
        
        // adding api key
        urlRequest.setValue("Token api_key=\(self.apiKey ?? "null")::\(self.partnerKey)", forHTTPHeaderField: "Authorization")
        
        self.socket = WebSocket(request: urlRequest)
        self.socket.connect()
    }
    
    func sendMessage(message : String) {
        let jsonMap: [String: Any] = [
            "command": "message",
            "identifier": "{\"channel\":\"WebNotificationsChannel\"}",
            "data": "{\"message\":\"" + message + "\"}"
        ]
        
        let json: Data
        do {
            json = try JSONSerialization.data(withJSONObject: jsonMap, options: [])
            self.sendData(d: json)
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
    }

    func updateLocation(location : CLLocation) {
        if (connected) {
            self.sendMessage(message: "update-location;" + self.apiKey! + ";\(location.coordinate.latitude);\(location.coordinate.longitude)")
        } else {
            self.lastLocation = location
        }
    }
    
     func flushLastLocation() {
        if (self.lastLocation != nil) {
            self.updateLocation(location: self.lastLocation!)
            self.lastLocation = nil
        }
    }
    
     func onMessageReceived(message : String) {
        if (self.delegate != nil) {
            self.delegate!.instachkOnMessageReceived(message: message)
        }
    }
    
    func setDelegate(delegate : MessageListener) {
        self.delegate = delegate
    }
    
    func sendData(d : Data) {
        if let string = String(data: d, encoding: String.Encoding.utf8) {
             self.socket.write(string: string)
        }
    }
}

extension InstachkService : WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        let jsonMap: [String: Any] = [
            "command": "subscribe",
            "identifier": "{\"channel\":\"" + "WebNotificationsChannel" + "\"}"
        ]
        
        let json: Data
        do {
            json = try JSONSerialization.data(withJSONObject: jsonMap, options: [])
            self.sendData(d: json)
        } catch {
            print("Error: cannot create JSON for subscribe")
            return
        }
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        self.connected = false
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("\(data)")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        do {
            let data = text.data(using: String.Encoding.utf8)!
            guard let json = try JSONSerialization.jsonObject(with: data, options: [])
                as? [String: Any]   else {
                    return
            }
            
            if let type = json["type"] as? String {
                if ("welcome" == type) {
                    self.connected = true
                    self.sendMessage(message: "insta-connection;" + self.apiKey!)
                    self.initializeLocationManager()
                    self.flushLastLocation()
                }
                if ("ping" != type) {
                    self.onMessageReceived(message: text);
                } else {
                    self.flushLastLocation()
                }
            } else {
                if let message = json["message"] as? String {
                    self.onMessageReceived(message: message)
                }
            }
        } catch  {
            print("Error parsing message response")
            return
        }
  }
}

extension InstachkService : CLLocationManagerDelegate {
    func initializeLocationManager() {
        self.locationManager = CLLocationManager()
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        locationManager!.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation: CLLocation = locations[locations.count - 1]
        let distanceThreshold : CLLocationDistance = 10
        
        if (self.lastUpdatedLocation == nil || self.lastUpdatedLocation!.distance(from: latestLocation) > distanceThreshold) {
            self.lastLocation = latestLocation
            self.lastUpdatedLocation = self.lastLocation
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print("\(error.localizedDescription)")
    }
}
