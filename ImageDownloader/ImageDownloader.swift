//
//  ImageDownloader.swift
//  ImageDownloader
//
//  Created by Daniel Eggert on 22/06/2014.
//  Copyright (c) 2014 objc.io. All rights reserved.
//

import Foundation



class ImageDownloader : NSObject, ImageDownloaderProtocol {
    let session: NSURLSession

    var appConnection: NSXPCConnection?

    var counter = 0

    var timer:NSTimer?

    override init()  {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config)

        super.init()
    }
    
    func downloadImageAtURL(url: NSURL!, withReply: ((NSData!)->Void)!) {
        let task = session.dataTaskWithURL(url) {
            data, response, error in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch (data, httpResponse) {
                case let (d, r) where (200 <= r.statusCode) && (r.statusCode <= 399):
                    withReply(d)
                default:
                    withReply(nil)
                }
            }
        }

        task.resume()

        if timer == nil {
//            timer = NSTimer(timeInterval: 5, target: self, selector: "talkBackToApp", userInfo: nil, repeats: true)
//            timer = NSTimer(timeInterval: 5, target: self, selector: "talkBackToAppWithMessage", userInfo: nil, repeats: true)
            timer = NSTimer(timeInterval: 5, target: self, selector: "talkBackToAppWithMessages", userInfo: nil, repeats: true)
            timer?.fire()
        }
    }

    func talkBackToApp() {
        if let appCounterPart = appConnection?.remoteObjectProxy as? AppPingBackProtocol {
            appCounterPart.pingAppBack()
        }
    }

    func talkBackToAppWithMessage() {
        if let appCounterPart = appConnection?.remoteObjectProxy as? AppPingBackProtocol {
            let aMessage = CustomClass()
            aMessage.attr1 = counter++
            appCounterPart.pingAppBackWithMessage(aMessage)
        }
    }

    func talkBackToAppWithMessages() {
        if let appCounterPart = appConnection?.remoteObjectProxy as? AppPingBackProtocol {
            let aMessage1 = CustomClass()
            aMessage1.attr1 = counter++
            let aMessage2 = CustomClass()
            aMessage2.attr1 = counter++

            appCounterPart.pingAppBackWithMessages([aMessage1, aMessage2])
        }
    }



}
