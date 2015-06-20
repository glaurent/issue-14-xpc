//
//  AppPingBackProtocol.swift
//  Superfamous Images
//
//  Created by Guillaume Laurent on 20/06/15.
//  Copyright © 2015 objc.io. All rights reserved.
//

import Foundation


@objc(AppPingBackProtocol)
protocol AppPingBackProtocol {
    func pingAppBack()
    func pingAppBackWithMessage(message:CustomClass)
    func pingAppBackWithMessages(messages:NSArray)
}