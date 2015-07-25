//
//  CustomClass.swift
//  Superfamous Images
//
//  Created by Guillaume Laurent on 20/06/15.
//  Copyright © 2015 objc.io. All rights reserved.
//

import Cocoa

@objc(CustomClass) class CustomClass: NSObject, NSSecureCoding {

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
        attr1 = aDecoder.decodeIntegerForKey("attr1")
        attr2 = aDecoder.decodeObjectOfClass(NSString.self, forKey: "attr2") as! String

//        attr2 = aDecoder.decodeObjectOfClass(String.self, forKey: "attr2") as! String

    }

    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(attr1, forKey: "attr1")
        aCoder.encodeObject(attr2, forKey: "attr2")
    }

    static func supportsSecureCoding() -> Bool {
        return true
    }

}
