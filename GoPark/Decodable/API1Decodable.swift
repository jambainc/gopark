//
//  API1Decodable.swift
//  GoPark
//
//  Created by Michael Wong on 28/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import Foundation

struct API1Decodable: Decodable {
    let bayid: Int
    let lat: Double
    let lon: Double
    let typedesc: String
    let duration: Int
    
    init(json: [String: Any]) {
        bayid = json["bayid"] as? Int ?? -1
        lat = json["lat"] as? Double ?? -1
        lon = json["long"] as? Double ?? -1
        typedesc = json["typeDesc"] as? String ?? ""
        duration = json["duration"] as? Int ?? -1
    }
}


