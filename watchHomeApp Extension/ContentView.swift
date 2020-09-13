//
//  ContentView.swift
//  watchHomeApp Extension
//
//  Created by Matthias Fischer on 04.09.20.
//  Copyright © 2020 Matthias Fischer. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var userData : UserData
    @State var isActive = false
    
    var body: some View {
        Form {
            HStack{
                HStack {
                    Image(systemName: "arrow.clockwise.circle").resizable().frame(width: 12.0, height: 12.0)
                    Text(userData.homeViewModel.timestamp).frame(maxWidth: .infinity).frame(height: 1).font(.footnote)
                }.onTapGesture {
                    loadModel(userData: self.userData)
                }
                NavigationLink(destination: SettingsViewWatch()) {
                    Image(systemName: "slider.horizontal.3").frame(maxWidth: .infinity).imageScale(.small)
                }.padding(0)
            }
            List(userData.homeViewModel.places) { place in
                VStack{
                    Text(place.name).foregroundColor(.white).font(Font.headline)
                    ForEach(place.values) { entry in
                        HStack{
                            Text(entry.key).foregroundColor(Color.init(hexString: entry.accent))
                            Spacer()
                            Text(entry.value).foregroundColor(Color.init(hexString: entry.accent))
                        }
                    }
                }
            }
        }.navigationBarTitle("Zuhause")
    }
    
}

extension Color {
    init(hex: Int) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255
        )
    }
    init(hexString: String) {
        var int: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&int)
        let r, g, b: UInt64
        (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: 1
        )
    }
}

#if DEBUG
enum MyDeviceNames: String, CaseIterable {
    case small = "Apple Watch Series 4 - 40mm"
    case large = "Apple Watch Series 4 - 44mm"
    
    static var all: [String] {
        return MyDeviceNames.allCases.map { $0.rawValue }
    }
}
struct SampleView_Previews_MyDevices: PreviewProvider {
    static var previews: some View {
        ForEach(MyDeviceNames.all, id: \.self) { devicesName in
            ContentView()
                .previewDevice(PreviewDevice(rawValue: devicesName))
                .previewDisplayName(devicesName)
        }
    }
}
#endif
