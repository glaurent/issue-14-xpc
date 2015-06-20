//
//  CustomClass.swift
//  Superfamous Images
//
//  Created by Guillaume Laurent on 20/06/15.
//  Copyright © 2015 objc.io. All rights reserved.
//

import Cocoa

class Foo {

}

class CustomClass: NSObject, NSSecureCoding {

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
//        attr2 = aDecoder.decodeObjectOfClass(NSString.self, forKey: "attr2") // won't compile yet, as of Xcode7 Beta1
    }

    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(attr1, forKey: "attr1")
        aCoder.encodeObject(attr2, forKey: "attr2")
    }

    static func supportsSecureCoding() -> Bool {
        return true
    }

}
