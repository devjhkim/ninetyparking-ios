//
//  SignupView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 9/1/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI
import KakaoOpenSDK
import NaverThirdPartyLogin
import FBSDKLoginKit
import FBSDKCoreKit

struct SignupView: View {
    
    @State var showEmailSignupView = false
    
    @State var loginResult = LoginResult()
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var login: LogIn
    
    var body: some View {
        ZStack{
            Color.white
                .edgesIgnoringSafeArea(.all)
           VStack {
                
            NavigationLink(destination: EmailSignupView(), isActive: self.$login.showEmailSignupView){
                    Button(action: {
                        self.login.showEmailSignupView = true
                    }){
                        Image("emailSignupButton")
                        
                    }
                }
                
                KakaoSignupButton()
                        .frame(width: 200, height: 30)
                        .padding(.top, 30)
                    
                    
                NaverSignupButton(loginResult: self.$loginResult)
                        .frame(width: 200, height: 30)
                        .padding(.top, 30)
                    
                    
                FacebookSignupButton(loginResult: self.$loginResult)
                        .frame(width: 200, height: 30)
                        .padding(.top, 30)
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}

struct KakaoSignupButton: UIViewRepresentable {
    
    
    @EnvironmentObject var login: LogIn
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIButton {
        let kakaoSignupButton = UIButton()
        kakaoSignupButton.setImage(UIImage(named: "kakaoSignupButton"), for: .normal)
        kakaoSignupButton.addTarget(context.coordinator, action: #selector(context.coordinator.login(_:)), for: .touchUpInside)
        return kakaoSignupButton
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) {
        
    }
    
    class Coordinator: NSObject {
        
        var button : KakaoSignupButton
        
        init(_ button: KakaoSignupButton){
            self.button = button
        }
        
        @objc func login( _ sender: UIButton){
            guard let session = KOSession.shared() else {
                return
            }

            if session.isOpen() {
                session.close()
            }
            
            session.open(completionHandler: { (error) -> Void in
                
                if !session.isOpen() {
                    if let error = error as NSError? {
                        switch error.code {
                        case Int(KOErrorCancelled.rawValue):
                            break
                        default:
                            print(error.description)
                        }
                    }
                }else{
                    
                    
                    
                    KOSessionTask.userMeTask(completion: {(error, me) in
                        if error != nil {
                            
                        }else{
                            
                            
                            if let myinfo = me as KOUserMe? {
                                
                                
                                if let myKakaoId = myinfo.id {
                                    
                                    self.button.login.kakaoId = myKakaoId
                                    self.button.login.showEmailSignupView = true
                                    
                                }
                            }
                        }
                    })
                    
                }
            })
        }
    }
    
}

struct NaverSignupButton: UIViewRepresentable {
    
    @Binding var loginResult: LoginResult
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    func makeUIView(context: Context) -> UIButton {
        let naverSignupButton = UIButton()
        naverSignupButton.setImage(UIImage(named: "naverSignupButton"), for: .normal)
        naverSignupButton.addTarget(context.coordinator, action: #selector(context.coordinator.login(_:)), for: .touchUpInside)
        return naverSignupButton
        
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, NaverThirdPartyLoginConnectionDelegate {
        var button : NaverSignupButton
         
         init(_ button: NaverSignupButton){
             
             self.button = button
             
         }
         
         @objc func login(_ sender: UIButton){
             self.button.loginInstance?.requestDeleteToken()
             self.button.loginInstance?.delegate = self
             self.button.loginInstance?.requestThirdPartyLogin()
         }
         
         private func getNaverInfo() {
             guard let isValidAccessToken = self.button.loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
            
             if !isValidAccessToken {
                 return
             }
            
             guard let tokenType = self.button.loginInstance?.tokenType else { return }
             guard let accessToken = self.button.loginInstance?.accessToken else { return }
             
             let urlStr = "https://openapi.naver.com/v1/nid/me"
             let url = URL(string: urlStr)!
            
             let authorization = "\(tokenType) \(accessToken)"
             
             let headers = ["Authorization": authorization]

             var request = URLRequest(url: url)
             
             for (key, value) in headers {
                 request.setValue(value, forHTTPHeaderField: key)
             }
             
             URLSession.shared.dataTask(with: request) { (data, response, error) in
                 if data == nil {
                     return
                 }

                 do{
                     if let rawData = data {
                         let json = try JSONSerialization.jsonObject(with: rawData, options: []) as? [String:Any]
                         
                         if let json = json {
                            guard let obj = json["response"] as? [String:Any] else { return }
                            guard let naverId = obj["id"] as? String else { return }
                             
                            DispatchQueue.main.async {
                                     
                            }
                         }
                     }

                 }catch{
                     fatalError(error.localizedDescription)
                 }
                 
             }.resume()
            
          }

         
         func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
             getNaverInfo()
         }
        
         func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
            
         }
        
         func oauth20ConnectionDidFinishDeleteToken() {
            self.button.loginInstance?.requestThirdPartyLogin()
         }
        
         func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
            
         }
    }
}

struct FacebookSignupButton: UIViewRepresentable {
    
    @Binding var loginResult: LoginResult
    
    func makeUIView(context: Context) -> UIButton {
        let facebookSignupButton = UIButton()
        facebookSignupButton.setImage(UIImage(named: "facebookSignupButton"), for: .normal)
        facebookSignupButton.addTarget(context.coordinator, action: #selector(context.coordinator.handleLogin(_:)), for: .touchUpInside)
        return facebookSignupButton
        
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var button: FacebookSignupButton
        
        init(_ button: FacebookSignupButton){
            self.button = button
        }
        
        @objc func handleLogin(_ sender: UIButton) {
            let loginManager = LoginManager()
            loginManager.logIn(permissions: ["public_profile"], viewController: nil){ loginResult in
                
                switch loginResult {
                case .failed(let error):
                    print(error)
                case .cancelled:
                    print("User cancelled login.")
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    print("Logged in! \(grantedPermissions) \(declinedPermissions) \(accessToken)")
                    GraphRequest(graphPath: "me", parameters: ["fields": "id"]).start(completionHandler: { (connection, result, error) -> Void in
                        if (error == nil){
                            let fbDetails = result as! NSDictionary
                            print(fbDetails)
                            
                            if let facebookId = fbDetails["id"] as? String{
                                
                            
                                
                            }
                        }
                    })
                }
            }

        }
    }
}
