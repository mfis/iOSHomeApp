//
//  SettingsView.swift
//  iOSHomeApp
//
//  Created by Matthias Fischer on 01.09.20.
//  Copyright © 2020 Matthias Fischer. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject private var userData : UserData
    @State var stateName = "circle"
    @State var loginMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text("Adresse der Client Anwendung"), footer: Text("Installation siehe: https://github.com/mfis/Home")){
                    TextField("URL", text: $userData.settingsUrl).keyboardType(.URL).disableAutocorrection(true).autocapitalization(.none)
                }
                
                Section(header: Text("Authentifizierung")){
                    TextField("Anmeldename", text: $userData.settingsUserName).disableAutocorrection(true).autocapitalization(.none)
                    SecureField("Passwort", text: $userData.settingsUserPassword).disableAutocorrection(true).autocapitalization(.none)
                }
                
                Section(footer: Text(loginMessage)){
                    HStack{
                        Button(action: {
                            self.signIn()
                        }) {
                            Text("Anmelden")
                        }
                        Spacer()
                        Image(systemName: stateName).imageScale(.medium)
                    }
                }
                
            }.navigationBarTitle(Text("Einstellungen"))
        }.onAppear(){
            self.userData.settingsUrl = self.userData.homeUrl
            self.userData.settingsUserName = self.userData.homeUserName
            self.userData.settingsUserPassword = ""
        }
    }
    
    fileprivate func cleanupUrl(forUrl: String) -> String{
        
        var url = forUrl.lowercased()
        
        if(!url.starts(with: "http://") && !url.starts(with: "https://")){
            url = "https://" + url
        }
        
        if(!url.hasSuffix("/")){
            url = url + "/"
        }
        return url
    }
    
    func signIn(){
        
        var urlString = userData.settingsUrl
        urlString = cleanupUrl(forUrl: urlString)
        validateLogin(urlString)
        
        DispatchQueue.main.async() {
            self.stateName = "circle"
        }
    }
    
    func validateLogin(_ urlString : String) {
        
        let whoami = urlString + "whoami"
        print("isValidHomeClientUrl for: " + whoami)
        let url = URL(string: whoami)
        guard let requestUrl = url else { fatalError() }
        let timeout : TimeInterval = 3.0
        var request = URLRequest(url: requestUrl, timeoutInterval: timeout)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error took place \(error)")
                self.showLoginResult(state: false)
                DispatchQueue.main.async() {
                    self.loginMessage = "Keine Home-Client Installation unter URL vorhanden."
                }
                return
            }
            guard let data = data else {return}
            let dataString = String(data: data, encoding: String.Encoding.utf8)! as String
            if(dataString == "de.fimatas.home.client"){
                self.auth(urlString)
            }
        }
        task.resume()
    }
    
    func auth(_ urlString : String){
        
        let url = URL(string: urlString + "createAuthToken")
        guard let requestUrl = url else { fatalError() }
        let timeout : TimeInterval = 5.0
        var request = URLRequest(url: requestUrl, timeoutInterval: timeout)
        request.httpMethod = "POST"
        let params = "user=\(urlEncode(userData.settingsUserName))&pass=\(urlEncode(userData.settingsUserPassword))&device=\(urlEncode(UIDevice.current.name))"
        request.httpBody = params.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error took place \(error)")
                DispatchQueue.main.async() { // TODO: centralize
                    self.userData.settingsUserPassword = ""
                }
                return
            }
            guard let data = data else {return}
            do{
                let model = try JSONDecoder().decode(TokenCreationResponseModel.self, from: data)
                
                if(model.success){
                    DispatchQueue.main.async() {
                        self.userData.homeUrl = urlString
                        self.userData.settingsUrl = urlString
                        self.userData.lastCalledUrl = ""
                        saveUrl(newUrl: urlString)
                        
                        self.userData.homeUserName = self.userData.settingsUserName
                        saveUserName(newUserName: self.userData.homeUserName)
                        
                        self.userData.homeUserToken = model.token
                        saveUserToken(newUserToken: model.token)
                        
                        self.showLoginResult(state: true)
                        self.loginMessage = "Die Anmeldung war erfolgreich."
                    }
                }else{
                    print("Response data: \(model.success) Token: \(model.token)")
                    DispatchQueue.main.async() {
                        self.showLoginResult(state: false)
                        self.loginMessage = "Die Anmeldung war nicht erfolgreich."
                    }
                }
                return
                
            }catch let err{
                print(err)
            }
            
            self.showLoginResult(state: false)
            DispatchQueue.main.async() {
                self.loginMessage = "Bei der Anmeldung ist ein Fehler aufgetreten."
                self.userData.settingsUserPassword = ""
            }
        }
        task.resume()
    }
    
    func showLoginResult(state : Bool){
        DispatchQueue.main.async() {
            if(state==true){
                self.stateName = "checkmark.circle.fill"
            }else{
                self.stateName = "bolt.horizontal.circle.fill"
            }
        }
    }
    
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    
    @State static var userData = UserData()
    
    static var previews: some View {
        SettingsView().environmentObject(self.userData)
    }
}
#endif

