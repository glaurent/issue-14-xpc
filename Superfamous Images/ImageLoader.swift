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
        connection.remoteObjectInterface = NSXPCInterface(with: ImageDownloaderProtocol.self)

        // add CustomClass to classes that can be passed through the XPC connection (sent from the XPC module back to this app)
        //
        let interface = NSXPCInterface(with: AppPingBackProtocol.self)

        // pingAppBackWithMessage(message:)
        //
        let currentExpectedClasses = interface.classes(for: #selector(pingAppBackWithMessage(message:)), argumentIndex: 0, ofReply: false) as NSSet
        let allClasses = currentExpectedClasses.adding(CustomClass.self)
        interface.setClasses(allClasses as Set<NSObject>, for: #selector(pingAppBackWithMessage(message:)), argumentIndex: 0, ofReply: false)

        // pingAppBackWithMessages(messages:)
        //
        let currentExpectedClasses2 = interface.classes(for:#selector(pingAppBackWithMessages(messages:)), argumentIndex: 0, ofReply: false) as NSSet
        let allClasses2 = currentExpectedClasses2.adding(CustomClass.self)
        interface.setClasses(allClasses2 as Set<NSObject>, for: #selector(pingAppBackWithMessages(messages:)), argumentIndex: 0, ofReply: false)

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
    
    func retrieveImageAtURL(_ url: URL, completionHandler: @escaping (NSImage?)->Void) {
        
        let downloader = self.imageDownloadConnection.remoteObjectProxyWithErrorHandler {
            (error) in
            NSLog("remote proxy error: \(error)")
            } as! ImageDownloaderProtocol
        downloader.downloadImageAtURL(url) {
            data in
            guard let data = data as NSData? else { return }
            DispatchQueue.global().async {
                if let source = CGImageSourceCreateWithData(data, nil), let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) {
                    let size = CGSize(
                        width: CGFloat(cgImage.width),
                        height: CGFloat(cgImage.height))
                    let image = NSImage(cgImage: cgImage, size: size)
                    completionHandler(image)
                } else {
                    completionHandler(nil)
                }

            }

        }
    }

    @objc func pingAppBack() {
        NSLog("ping back received");
    }

    @objc func pingAppBackWithMessage(message:CustomClass) {
        NSLog("ping back received with message :\(message)");
    }

    @objc func pingAppBackWithMessages(messages:NSArray) {
        if let messagesSW = messages as? Array<CustomClass> {
            for m in messagesSW {
                NSLog("message : \(m)")
            }
        }
    }

}
