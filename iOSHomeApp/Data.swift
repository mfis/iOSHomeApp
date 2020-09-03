//
//  Data.swift
//  iOSHomeApp
//
//  Created by Matthias Fischer on 01.09.20.
//  Copyright © 2020 Matthias Fischer. All rights reserved.
//

import Foundation

struct TokenCreationResponseModel: Codable {
    var success: Bool
    var token: String
}

let userDefaults = UserDefaults.standard

let dataUrl = loadUrl()
let dataUserName = loadUserName()
let dataUserToken = loadUserToken()

func loadUrl() -> String {
    print("CALL LOADURL")
    if let x = userDefaults.string(forKey: "userDefaultKeyUrl") {
        return x
    }else{
        return ""
    }
}

func saveUrl(newUrl : String) {
    userDefaults.setValue(newUrl, forKey: "userDefaultKeyUrl")
}

func loadUserName() -> String {
    if let x = userDefaults.string(forKey: "userDefaultKeyUserName") {
        return x
    }else{
        return ""
    }
}

func saveUserName(newUserName : String) {
    userDefaults.setValue(newUserName, forKey: "userDefaultKeyUserName")
}

func loadUserToken() -> String {
    if let x = userDefaults.string(forKey: "userDefaultKeyUserToken") {
        return x
    }else{
        return ""
    }
}

func saveUserToken(newUserToken : String) {
    userDefaults.setValue(newUserToken, forKey: "userDefaultKeyUserToken")
}

func urlEncode(_ string : String) -> String {
    let encoded = string.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
    return encoded!
}
