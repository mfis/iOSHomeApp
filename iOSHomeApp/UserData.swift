//
//  UserData.swift
//  iOSHomeApp
//
//  Created by Matthias Fischer on 01.09.20.
//  Copyright © 2020 Matthias Fischer. All rights reserved.
//

import Combine
import SwiftUI

final class UserData: ObservableObject {
     
    @Published var homeUrl = dataUrl
    @Published var settingsUrl = dataUrl
    @Published var lastCalledUrl = ""
    
    @Published var homeUserName = dataUserName
    @Published var settingsUserName = dataUserName
    
    @Published var homeUserToken = dataUserToken
    
    @Published var settingsUserPassword = ""
    
    @Published var loginState = ""
    
    @Published var webViewTitle = ""
    
    @Published var isInBackground = false
    
}
