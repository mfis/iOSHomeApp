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
    
    var userData : UserData!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.userData = (WKExtension.shared().delegate as! ExtensionDelegate).userData
    }
    
    override var body: AnyView {
        return AnyView(ContentView().environmentObject(userData))
    }
}
