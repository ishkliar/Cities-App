//
//  City.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 02/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import Foundation

struct City: Decodable {
    let id: String
    let name: String
    let country: String
    let image: URL
}
