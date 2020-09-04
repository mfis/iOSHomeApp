//
//  ContentView.swift
//  iOSHomeApp
//
//  Created by Matthias Fischer on 01.09.20.
//  Copyright © 2020 Matthias Fischer. All rights reserved.
//

import SwiftUI
import WebKit

struct ContentView: View {
    
    @EnvironmentObject private var userData : UserData
    
    @ViewBuilder
    var body: some View {
        NavigationView{
            if(userData.isInBackground==true){
                BackgroundView()
            }else{
                Content()
            }
        }
    }
    
}

struct BackgroundView : View {
    
    var body: some View {
        Image(systemName: "house.fill").imageScale(.medium).onAppear(){print("house")}
    }
    
}

struct Content : View {
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont.systemFont(ofSize: 20.0, weight: .light)]
    }
    
    var body: some View {
        WebView()
            .navigationBarTitle(Text("Zuhause"), displayMode: .inline)
            .navigationBarItems(
                leading:  NavIconLeft(),
                trailing: NavIconRight()
        ).edgesIgnoringSafeArea(.bottom)
    }
    
}

struct NavIconLeft : View {
    
    @EnvironmentObject private var userData : UserData
    
    var body: some View {
        HStack{
            Image(systemName: "arrow.clockwise.circle").foregroundColor(Color.gray)
            Text(userData.webViewTitle).frame(width: 70, alignment: .leading).foregroundColor(Color.gray).font(.caption)
        }
    }
}

struct NavIconRight : View {
    
    @EnvironmentObject private var userData : UserData
    
    var body: some View {
        NavigationLink(destination: SettingsView()) {
            Image(systemName: "slider.horizontal.3")
        }.buttonStyle(PlainButtonStyle())
    }
}

struct WebView : UIViewRepresentable {
    
    @EnvironmentObject private var userData : UserData
    
    var webViewObserver = WebViewObserver();
    
    func makeUIView(context: Context) -> WKWebView  {
        
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webViewObserver.userData = userData
        webView.addObserver(webViewObserver, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        loadWebView(webView)
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        
        if(!userData.homeUrl.isEmpty && userData.lastCalledUrl != userData.homeUrl){
            loadWebView(webView)
        }
    }
    
    fileprivate func loadWebView(_ webView: WKWebView) {
        
        if userData.homeUrl.isEmpty {
            let fileUrl = Bundle.main.url(forResource: "signInFirst", withExtension: "html")!
            webView.loadFileURL(fileUrl, allowingReadAccessTo: fileUrl.deletingLastPathComponent())
            userData.lastCalledUrl = fileUrl.absoluteString
        }else{
            var request = URLRequest.init(url: URL.init(string: userData.homeUrl)!)
            request.addValue(userData.homeUserName, forHTTPHeaderField: "appUserName")
            request.addValue(userData.homeUserToken, forHTTPHeaderField: "appUserToken")
            request.addValue(UIDevice.current.name, forHTTPHeaderField: "appDevice")
            webView.load(request)
            userData.lastCalledUrl = userData.homeUrl
        }
    }
    
    func dismantleUIView(_ uiView: Self.UIViewType, coordinator: Self.Coordinator){
        uiView.removeObserver(webViewObserver, forKeyPath: #keyPath(WKWebView.title))
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    
    @State static var userData = UserData()
    
    static var previews: some View {
        ContentView().environmentObject(self.userData)
    }
}
#endif
