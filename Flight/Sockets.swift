//
//  Sockets.swift
//  Flight
//
//  Created by Eli Zhang on 5/5/20.
//  Copyright © 2020 Eli Zhang. All rights reserved.
//

import SocketIO
import SwiftyJSON
import Foundation

class Sockets {
    static let serverURL = "http://192.168.1.24:8000"
    
    static var manager: SocketManager!
    static var socket: SocketIOClient!
    
    static func connect(completion: @escaping () -> Void) {
        self.manager = SocketManager(socketURL: URL(string: serverURL)!, config: [.log(false)])
        self.socket = manager.defaultSocket
        socket.on("error") { data, ack  in
            print("Socket error: \(data)")
        }
        socket.on("connect") { data, ack in
            print("Socket connected.")
        }
        socket.on("disconnect") { data, ack in
            print("Socket disconnected.")
        }
        socket.connect()
    }
    
    static func isConnected() -> Bool {
        if socket == nil {
            return false
        } else {
            while socket.status == .connecting {
                print("connecting...")
            }
            return socket.status == .connected
        }
    }
    
    static func takePhoto() {
        socket.emit("take_photo") {}
    }
    
    static func resumeVideo() {
        socket.emit("resume_video") {}
    }
    
    static func processJSONData(data: [Any], callback: @escaping (JSON) -> Void) {
        guard let jsonData = data.first else {
            return
        }
        if !JSONSerialization.isValidJSONObject(jsonData) {
            return
        }
        guard let json = try? JSONSerialization.data(withJSONObject: jsonData) else {
            return
        }
        do {
            let jsonObject = try JSON(data: json)
            callback(jsonObject)
        } catch {
            print("JSON Error: \(error)")
        }
    }
    
    static func registerImageHandler(imageFunction: @escaping (UIImage) -> Void) {
        socket.on("live_preview_image") { data, ack in
            self.processJSONData(data: data, callback: { encodedData in
                let encodedBuffer = encodedData["buffer"].stringValue
                if let decodedImageData = Data(base64Encoded: encodedBuffer, options: .ignoreUnknownCharacters) {
                    if let image = UIImage(data: decodedImageData) {
                        imageFunction(image)
                    }
                }
            })
        }
    }
    
    static func unregisterImageHandler() {
        socket.off("message")
    }
}
