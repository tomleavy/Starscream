//
//  SocksProxy.swift
//  Starscream
//
//  Created by Tom Leavy on 6/18/18.
//  Copyright © 2018 Vluxe. All rights reserved.
//

import Foundation

public protocol SocksProxy {
    var host : String { get }
    var port : UInt16 { get }
    func settingsDictionary() -> CFDictionary
}

public struct CustomSocksProxy : SocksProxy {
    
    public let host : String
    public let port : UInt16
    
    public init(host: String, port: UInt16) {
        self.host = host
        self.port = port
    }
    
    public func settingsDictionary() -> CFDictionary {
        var dictionary = [AnyHashable: Any]()
        dictionary[kCFStreamPropertySOCKSProxy as String] = 1
        dictionary[kCFStreamPropertySOCKSProxyHost as String] = host
        dictionary[kCFStreamPropertySOCKSProxyPort as String] = port
        return dictionary as CFDictionary
    }
    
}

public struct SystemSocksProxy {
    
    private var dictionary = [AnyHashable: Any]()
    
    init() {
        if let proxyDict = CFNetworkCopySystemProxySettings() {
            self.dictionary = CFDictionaryCreateMutableCopy(nil, 0, proxyDict.takeRetainedValue()) as! [AnyHashable: Any]
        }
    }
    
    var host : String {
        get {
            return dictionary[kCFStreamPropertySOCKSProxyHost as String] as? String ?? ""
        }
    }
    
    var port : UInt16 {
        get {
            return dictionary[kCFStreamPropertySOCKSProxyPort as String] as? UInt16 ?? 0
        }
    }
    
    func settingsDictionary() -> CFDictionary {
        return dictionary as CFDictionary
    }
}
