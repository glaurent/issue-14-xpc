//
//  CustomClass.swift
//  Superfamous Images
//
//  Created by Guillaume Laurent on 20/06/15.
//  Copyright © 2015 objc.io. All rights reserved.
//

import Cocoa

@objc(CustomClass) class CustomClass: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true

    var attr1 = 0
    var attr2 = "foobar"

    override var description:String {
        get {
            return "attr1 : \(attr1) - attr2 : \(attr2)"
        }
    }

    override init() {
        super.init()
    }

    @objc required init?(coder aDecoder: NSCoder) {
        attr1 = aDecoder.decodeInteger(forKey:"attr1")
        let attr2Tmp = aDecoder.decodeObject(of:NSString.self, forKey: "attr2")
        attr2 = (attr2Tmp ?? "noValue") as String

//        attr2 = aDecoder.decodeObjectOfClass(String.self, forKey: "attr2") as! String

    }

    @objc func encode(with aCoder: NSCoder) {
        aCoder.encode(attr1, forKey: "attr1")
        aCoder.encode(attr2, forKey: "attr2")
    }

}
