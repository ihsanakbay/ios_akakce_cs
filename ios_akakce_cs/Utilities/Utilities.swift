//
//  Utilities.swift
//  ios_akakce_cs
//
//  Created by İhsan Akbay on 11.03.2025.
//

import Foundation

/// Get the environment values
var ENV: ApiKeyable {
    #if DEBUG
    return ConfigEnv()
    #else
    return ConfigEnv()
    #endif
}

protocol ApiKeyable {
    var API_KEY: String { get }
    var API_HOST: String { get }
}

/// Read plist
class BaseEnv {
    enum Key: String {
        case API_KEY
        case API_HOST
    }

    let dict: NSDictionary

    init(resourceName: String) {
        guard let filePath = Bundle.main.path(forResource: resourceName, ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath)
        else {
            fatalError("Couldn't find file '\(resourceName)' plist")
        }
        self.dict = plist
    }
}

/// The name "Config" is a plist file
class ConfigEnv: BaseEnv, ApiKeyable {
    init() {
        super.init(resourceName: "Config")
    }

    var API_KEY: String {
        dict.object(forKey: Key.API_KEY.rawValue) as? String ?? ""
    }

    var API_HOST: String {
        dict.object(forKey: Key.API_HOST.rawValue) as? String ?? ""
    }
}
