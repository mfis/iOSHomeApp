//
//  HostingController.swift
//  watchHomeApp Extension
//
//  Created by Matthias Fischer on 04.09.20.
//  Copyright © 2020 Matthias Fischer. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<AnyView> {
    
    private var userData = UserData()
    
    override var body: AnyView {
        return AnyView(ContentView().environmentObject(userData))
    }
}
