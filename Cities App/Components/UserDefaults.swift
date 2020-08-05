//
//  UserDefaults.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 03/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T?

    init(key: String, defaultValue: T? = nil) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T? {
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }

        get {
            UserDefaults.standard.value(forKey: key) as? T ?? defaultValue
        }
    }
}
