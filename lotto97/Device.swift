//
//  Device.swift
//  lotto97
//
//  Created by Adam Novak on 2022/12/09.
//

import Foundation

struct Device: Codable {
    var hasRatedApp: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case hasRatedApp
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hasRatedApp = try values.decodeIfPresent(Bool.self, forKey: .hasRatedApp) ?? false
    }
    
    init() {
        hasRatedApp = false
    }
    
}
