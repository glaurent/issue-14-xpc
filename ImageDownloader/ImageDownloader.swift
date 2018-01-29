//
//  ImageDownloader.swift
//  ImageDownloader
//
//  Created by Daniel Eggert on 22/06/2014.
//  Copyright (c) 2014 objc.io. All rights reserved.
//

import Foundation



class ImageDownloader : NSObject, ImageDownloaderProtocol {
    let session: URLSession

    var appConnection: NSXPCConnection?

    var counter = 0

    var timer:Timer?

    override init()  {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)

        super.init()
    }
    
    func downloadImageAtURL(_ url: URL, withReply: ((Data?)->Void)?) {
        let task = session.dataTask(with: url as URL) {
            data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                switch (data, httpResponse) {
                case let (d, r) where (200 <= r.statusCode) && (r.statusCode <= 399):
                    withReply?(d)
                default:
                    withReply?(nil)
                }
            }
        }

        task.resume()

        if timer == nil {
            timer = Timer(timeInterval: 5, repeats: true, block: { (_) in
//                self.talkBackToApp()
//                self.talkBackToAppWithMessage()
                self.talkBackToAppWithMessages()
            })
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
            counter += 1
            aMessage.attr1 = counter
            appCounterPart.pingAppBackWithMessage(message:aMessage)
        }
    }

    @objc func talkBackToAppWithMessages() {
        if let appCounterPart = appConnection?.remoteObjectProxy as? AppPingBackProtocol {
            let aMessage1 = CustomClass()
            counter += 1
            aMessage1.attr1 = counter
            let aMessage2 = CustomClass()
            counter += 1
            aMessage2.attr1 = counter

            appCounterPart.pingAppBackWithMessages(messages: [aMessage1, aMessage2])
        }
    }



}
