//
//  Data++.swift
//  ILSANG
//
//  Created by Lee Jinhee on 8/13/24.
//

import Foundation

extension Data {
    var bytes: Int64 {
        .init(self.count)
    }
    
    public var kilobytes: Double {
        return Double(bytes) / 1_024
    }
    
    public var megabytes: Double {
        return kilobytes / 1_024
    }
    
    public var gigabytes: Double {
        return megabytes / 1_024
    }
}
