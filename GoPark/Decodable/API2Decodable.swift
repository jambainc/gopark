//
//  API2Decodable.swift
//  GoPark
//
//  Created by Michael Wong on 28/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import Foundation

struct API2Decodable: Decodable {
    let adjFromDay: Int?
    let adjStartTime: String?
    let adjToDay: Int?
    let adjEndTime: String?
    let bayid: Int?
    let disabilityext: Int?
    let duration: Int?
    let effectiveonph: Int?
    let exemption: String?
    let lat: Double?
    let lon: Double?
    let sign: String?
    let typedesc: String?
    
    
    /**
    init(json: [String: Any]) {
        
        adjFromDay = json["adjFromDay"] as? Int ?? -1
        adjStartTime = json["adjStartTime"] as? String ?? ""
        adjToDay = json["adjToDay"] as? Int ?? -1
        bayid = json["bayid"] as? Int ?? -1
        disabilityext = json["disabilityext"] as? Int ?? -1
        duration = json["duration"] as? Int ?? -1
        effectiveonph = json["effectiveonph"] as? Int ?? -1
        exemption = json["exemption"] as? String ?? ""
        lat = json["lat"] as? Double ?? -1
        lon = json["long"] as? Double ?? -1
        sign = json["sign"] as? String ?? ""
        typedesc = json["typeDesc"] as? String ?? ""
    }
     **/
}

