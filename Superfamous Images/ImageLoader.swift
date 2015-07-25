//
//  ImageLoader.swift
//  Superfamous Images
//
//  Created by Daniel Eggert on 21/06/2014.
//  Copyright (c) 2014 objc.io. All rights reserved.
//

import Cocoa
import ApplicationServices



class ImageLoader: NSObject, AppPingBackProtocol {
    
    // An XPC service
    lazy var imageDownloadConnection: NSXPCConnection = {
        let connection = NSXPCConnection(serviceName: "io.objc.Superfamous-Images.ImageDownloader")
        connection.remoteObjectInterface = NSXPCInterface(withProtocol: ImageDownloaderProtocol.self)

        // add CustomClass to classes that can be passed through the XPC connection (sent from the XPC module back to this app)
        //
        let interface = NSXPCInterface(withProtocol: AppPingBackProtocol.self)

        let currentExpectedClasses = interface.classesForSelector("pingAppBackWithMessages:", argumentIndex: 0, ofReply: false) as NSSet

        let allClasses = currentExpectedClasses.setByAddingObject(CustomClass.self)

        interface.setClasses(allClasses as Set<NSObject>, forSelector: "pingAppBackWithMessages:", argumentIndex: 0, ofReply: false)


        let currentExpectedClasses2 = interface.classesForSelector("pingAppBackWithMessages:", argumentIndex: 0, ofReply: false) as NSSet

        let allClasses2 = currentExpectedClasses2.setByAddingObject(CustomClass.self)

        interface.setClasses(allClasses2 as Set<NSObject>, forSelector: "pingAppBackWithMessage:", argumentIndex: 0, ofReply: false)

        // setup our side of the connection
        //
        connection.exportedInterface = interface
        connection.exportedObject = self

        connection.resume()
        return connection
    }()
    
    deinit {
        self.imageDownloadConnection.invalidate()
    }
    
    func retrieveImageAtURL(url: NSURL, completionHandler: (NSImage?)->Void) {
        
        let downloader = self.imageDownloadConnection.remoteObjectProxyWithErrorHandler {
            	(error) in NSLog("remote proxy error: %@", error)
            } as! ImageDownloaderProtocol
        downloader.downloadImageAtURL(url) {
            data in
            dispatch_async(dispatch_get_global_queue(0, 0)) {
                if let source = CGImageSourceCreateWithData(data, nil), cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) {
                    let size = CGSize(
                        width: CGFloat(CGImageGetWidth(cgImage)),
                        height: CGFloat(CGImageGetHeight(cgImage)))
                    let image = NSImage(CGImage: cgImage, size: size)
                    completionHandler(image)
                } else {
                    completionHandler(nil)
                }
            }
        }
    }

    func pingAppBack() {
        NSLog("ping back recevied");
    }

    func pingAppBackWithMessage(message:CustomClass) {
        NSLog("ping back recevied with message :\(message)");
    }

    func pingAppBackWithMessages(messages:NSArray) {
        if let messagesSW = messages as? Array<CustomClass> {
            for m in messagesSW {
                NSLog("message : \(m)")
            }
        }
    }

}
