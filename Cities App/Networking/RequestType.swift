//
//  RequestTask.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 02/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import Foundation

public enum RequestType {
    case requestPlain
    case requestParameters(parameters: [String: Any])
    case requestData(Data)
    case requestJSON(Encodable)
}
