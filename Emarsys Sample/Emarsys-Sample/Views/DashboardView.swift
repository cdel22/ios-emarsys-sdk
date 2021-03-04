//
//  Copyright © 2020. Emarsys. All rights reserved.
//

import SwiftUI
import EmarsysSDK

struct DashboardView: View {
    
    @EnvironmentObject var loginData: LoginData
    @State var isGeofenceEnabled: Bool = false
    @State var showSetupChangeMessage: Bool = false
    @State var messageText: String = ""
    @State var messageColor: UIColor = .green
    @State var showLoginMessage: Bool = false
    
    @State var deviceToken : Data?
    @State var changeEnv: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(spacing: 20) {
                    Text("Change SDK setup")
                        .bold()
                    
                    if(self.showSetupChangeMessage) {
                        Text(self.messageText).foregroundColor(Color(self.messageColor))
                    }
                    
                    FloatingTextField(title: "ApplicationCode", text: $loginData.applicationCode)
                    
                    FloatingTextField(title: "ContactFieldId", text: $loginData.contactFieldId)
                    
                    FloatingTextField(title: "MerchantId", text: $loginData.merchantId)
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            changeEnv.toggle()
                        }) {
                            Image(systemName: changeEnv ? "checkmark.square" : "square")
                        }
                        Text("change env")
                        
                        Spacer()
                        
                        Button(action: self.changeConfig) {
                            Text("Change")
                        }
                    }
                }.padding()
                
                Divider().background(Color.black).padding(.horizontal)
                
                VStack(spacing: 15) {
                    Text("Push token")
                        .bold()
                        .onReceive(NotificationCenter.default.publisher(for: .pushTokenReceived)) { object in
                            self.deviceToken = object.userInfo?["push_token"] as! Data
                        }
                    
                    HStack {
                        Spacer()
                        Button(action: self.setPushTokenButtonClicked) {
                            Text("Set")
                        }
                        Spacer()
                        Button(action: self.copyPushTokenButtonClicked) {
                            Text("Copy")
                        }
                        Spacer()
                    }
                }
                
                Divider().background(Color.black).padding(.horizontal)
                
                VStack(spacing: 15) {
                    Text("Geofence").bold()
                    Button(action: self.requestLocationPermission) {
                        Text("Request location permissions")
                    }
                    HStack {
                        Text("Enabled")
                        Toggle("Enabled", isOn: $isGeofenceEnabled).labelsHidden().onTapGesture {
                            if(self.isGeofenceEnabled) {
                                Emarsys.geofence.disable()
                            } else {
                                Emarsys.geofence.enable()
                            }
                        }
                    }
                }
                
                Divider().background(Color.black).padding(.horizontal)
                
                VStack(spacing: 20) {
                    Text("Contact identification")
                        .bold()
                    
                    if(self.showLoginMessage) {
                        Text(self.messageText).foregroundColor(Color(self.messageColor))
                    }
                    
                    if(self.loginData.isLoggedIn == false) {
                        FloatingTextField(title: "ContactFieldValue", text: $loginData.contactFieldValue).accessibility(identifier: "customFieldValue")
                    }
                    
                    HStack() {
                        Spacer()
                        Button(action: {
                            self.loginButtonClicked()
                        }) {
                            self.loginButtonText()
                        }
                    }
                    
//                    GoogleSignInButton()
//                        .frame(height: 44)
                }
                .padding()
                
            }
        }
    }
    
    func loginButtonText() -> Text {
        let buttonText = self.loginData.isLoggedIn ? "Logout" : "Login"
        return Text("\(buttonText)")
    }
    
    func loginButtonClicked(){
        if self.loginData.isLoggedIn == false {
            Emarsys.setContactWithContactFieldValue(loginData.contactFieldValue) { error in
                if error == nil {
                    print("setContact succesful")
                    self.loginData.isLoggedIn = true
                    UserDefaults.standard.set(self.loginData.contactFieldValue, forKey: "contactFieldValue")
                    showMessage(successful: true)
                } else {
                    showMessage(successful: false)
                }
            }
        } else {
            Emarsys.clearContact() { error in
                if error == nil {
                    self.loginData.isLoggedIn = false
                    UserDefaults.standard.set(nil, forKey: "contactFieldValue")
                    showMessage(successful: true)
                } else {
                    showMessage(successful: false)
                }
            }
        }
        self.showLoginMessage = true
    }
    
    func changeConfig() {
        if let myInteger = Int(self.loginData.contactFieldId) {
            let contactFieldId = NSNumber(value:myInteger)
            Emarsys.config.changeApplicationCode(self.loginData.applicationCode, contactFieldId: contactFieldId) { error in
                if (error == nil) {
                    self.showMessage(successful: true)
                    
                    let configUserDefaults = UserDefaults(suiteName: "com.emarsys.sampleConfig")
                    configUserDefaults?.set(self.loginData.contactFieldId, forKey: ConfigUserDefaultsKey.contactFieldId.rawValue)
                    configUserDefaults?.set(self.loginData.applicationCode,forKey: ConfigUserDefaultsKey.applicationCode.rawValue)
                    configUserDefaults?.set(self.loginData.merchantId,forKey: ConfigUserDefaultsKey.merchantId.rawValue)
                    
                    UserDefaults.standard.set(self.loginData.applicationCode, forKey: ConfigUserDefaultsKey.applicationCode.rawValue)
                    UserDefaults.standard.set(self.loginData.contactFieldId, forKey: ConfigUserDefaultsKey.contactFieldId.rawValue)
                    
                    self.doEnvironmentChange()
                } else {
                    self.showMessage(successful: false)
                    UserDefaults.standard.set(nil, forKey: ConfigUserDefaultsKey.applicationCode.rawValue)
                    UserDefaults.standard.set(nil, forKey: ConfigUserDefaultsKey.contactFieldId.rawValue)
                }
            }
        } else {
            self.showMessage(successful: false)
        }
        self.showSetupChangeMessage = true
    }
    
    func doEnvironmentChange() {
        if(changeEnv) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                exit(0)
            }
        }
    }
    
    func showMessage(successful: Bool) {
        if(successful) {
            self.messageText = "Successful"
            self.messageColor = .green
        } else {
            self.messageText = "Something went wrong"
            self.messageColor = .red
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
        hideMessage()
    }
    
    func hideMessage() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.showSetupChangeMessage = false
            self.showLoginMessage = false
        }
    }
    
    func setPushTokenButtonClicked() {
        if (self.deviceToken != nil) {
            Emarsys.push.setPushToken(deviceToken!) { error in
                if (error == nil) {
                    print("push token has been set")
                }
            }
        }
    }
    
    func copyPushTokenButtonClicked() {
        if (self.deviceToken != nil) {
            let pushToken = self.deviceToken!.map {
                String(format: "%02.2hhx", $0)
            }.joined()
            UIPasteboard.general.string = pushToken
        }
    }
    
    func requestLocationPermission() {
        print("requestLocationPermission clicked")
        Emarsys.geofence.requestAlwaysAuthorization()
    }
}


struct DashboardView_Previews: PreviewProvider {
    
    static var previews: some View {
        DashboardView().environmentObject(LoginData(isLoggedIn: true,
                                                    contactFieldValue: "test@test.com",
                                                    contactFieldId: "2545",
                                                    applicationCode: "EMS11-C3FD3",
                                                    merchantId: "testMerchantId"))
    }
}
