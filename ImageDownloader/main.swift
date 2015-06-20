//
//  ImageDownloaderMain.swift
//  ImageDownloader
//
//  Created by Daniel Eggert on 22/06/2014.
//  Copyright (c) 2014 objc.io. All rights reserved.
//

import Foundation



class ServiceDelegate : NSObject, NSXPCListenerDelegate {
    func listener(listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        newConnection.exportedInterface = NSXPCInterface(withProtocol: ImageDownloaderProtocol.self)
        let exportedObject = ImageDownloader()
        newConnection.exportedObject = exportedObject

        // setup connection from this service to the app
        //
        newConnection.remoteObjectInterface = NSXPCInterface(withProtocol: AppPingBackProtocol.self)

        exportedObject.appConnection = newConnection
        
        newConnection.resume()
        return true
    }
}


// Create the listener and resume it:
//
let delegate = ServiceDelegate()
let listener = NSXPCListener.serviceListener()
listener.delegate = delegate;
listener.resume()
