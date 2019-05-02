//
//  API3Decodable.swift
//  GoPark
//
//  Created by Michael Wong on 29/4/19.
//  Copyright © 2019 MWstudio. All rights reserved.
//

import Foundation

struct API3Decodable: Decodable {
    let bayid: Int?
    let lat: Double?
    let lon: Double?
    let address: String?
    let traveltime: Int?
    let cost: String?
    let duration: Int?
    let sign: String?
}
