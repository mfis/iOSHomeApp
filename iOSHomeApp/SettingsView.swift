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
    
    func signIn(){
        
        var urlString = userData.settingsUrl
        urlString = cleanupUrl(forUrl: urlString)
        validateLogin(urlString)
        
        DispatchQueue.main.async() {
            self.stateName = "circle"
        }
    }
    
    func validateLogin(_ urlString : String) {
        
        func onError(){
            self.showLoginResult(state: false)
            DispatchQueue.main.async() {
                self.loginMessage = "Keine Home-Client Installation unter URL vorhanden."
            }
        }
        
        func onSuccess(response : String){
            if(response == "de.fimatas.home.client"){
                self.auth(urlString)
            }
        }
        
        httpCall(urlString: urlString + "whoami", timeoutSeconds: 3.0, method: HttpMethod.GET, postParams: nil, errorHandler: onError, successHandler: onSuccess)
    }
    
    func auth(_ urlString : String){
        
        func onError(){
            self.showLoginResult(state: false)
            DispatchQueue.main.async() {
                self.loginMessage = "Verbindungsfehler!"
                self.userData.settingsUserPassword = ""
            }
        }
        
        func onSuccess(response : String){
            do{
                let model = try JSONDecoder().decode(TokenCreationResponseModel.self, from: response.data(using: .utf8)!)
                
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
                    DispatchQueue.main.async() {
                        self.showLoginResult(state: false)
                        self.loginMessage = "Die Anmeldung war nicht erfolgreich."
                    }
                }
                return
                
            }catch _{}
            
            self.showLoginResult(state: false)
            DispatchQueue.main.async() {
                self.loginMessage = "Bei der Anmeldung ist ein Fehler aufgetreten."
                self.userData.settingsUserPassword = ""
            }
        }
        
        let paramDict = ["user": userData.settingsUserName, "pass": userData.settingsUserPassword, "device" : UIDevice.current.name]
        
        httpCall(urlString: urlString + "createAuthToken", timeoutSeconds: 5.0, method: HttpMethod.POST, postParams: paramDict, errorHandler: onError, successHandler: onSuccess)
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

