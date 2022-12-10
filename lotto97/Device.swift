//
//  Device.swift
//  lotto97
//
//  Created by Adam Novak on 2022/12/09.
//

import Foundation

struct Device: Codable {
    var hasRatedApp: Bool = false
    var numberOfTries: Int = 0

    enum CodingKeys: String, CodingKey {
        case hasRatedApp
        case numberOfTries
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hasRatedApp = try values.decodeIfPresent(Bool.self, forKey: .hasRatedApp) ?? false
        numberOfTries = try values.decodeIfPresent(Int.self, forKey: .numberOfTries) ?? 0
    }
    
    init() {
        hasRatedApp = false
        numberOfTries = 0
    }
    
}
