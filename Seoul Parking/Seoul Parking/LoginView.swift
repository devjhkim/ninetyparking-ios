//
//  LoginView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 7/16/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI
import UIKit
import KakaoOpenSDK
import NaverThirdPartyLogin
import FBSDKLoginKit
import FBSDKCoreKit









struct LoginView: View {
    @State var showEmailLoginView = false
    @State var showEmailSignupView = false
    @State var showSignupView = false
    @State var loginResult = LoginResult()
    
    @EnvironmentObject var login: LogIn
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.showLoginView) var showLoginView
    
    
    var body: some View {
        NavigationView {
            VStack {
                
                Text(APP_TITLE)
                    .bold()
                    .font(.system(size: 40))
                
                NavigationLink(destination: EmailLoginView().environment(\.showLoginView, self.showLoginView), isActive: self.$showEmailLoginView){
                    Button(action: {
                        self.showEmailLoginView = true
                    }){
                        Image("emailLoginButton")
                            .padding(.top, 50)
                            
                    }
                }
                
                NavigationLink(destination: EmailSignupView(), isActive: self.$showEmailSignupView){
                    EmptyView()
                }.hidden()
                
                
                
                NavigationLink(destination: SignupView(), isActive: self.$showSignupView){
                    EmptyView()
                }.hidden()
                
                
                KakaoLoginButton()
                    .frame(width: 200, height: 30)
                    .padding(.top, 30)
                    
                
                NaverLoginButton()
                    .frame(width: 200, height: 30)
                    .padding(.top, 30)
                    
                
                FacebookLoginButton()
                    .frame(width: 200, height: 30)
                    .padding(.top, 30)
                
                HStack{
                    Text("회원이 아니신가요?")
                        .font(.system(size: 14))
                    
                    Text("여기를 클릭하여 회원가입을 해주세요.")
                        .underline()
                        .font(.system(size: 14, weight: .bold))
                        .padding(.leading, 5)
                    
                }
                .frame( height: 30)
                .frame(maxWidth:.infinity)
                .padding(.top, 30)
                .onTapGesture {
                    self.showSignupView = true
                }
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitle(Text(""), displayMode: .inline)
            .alert(isPresented: self.$login.showLoginAlert){
                Alert(title: Text("미가입 회원"), message: Text("존재하지 않는 ID입니다. 먼저 회원 가입을 해야 합니다."),
                      primaryButton: .cancel(Text("취소"), action: {}),
                      secondaryButton: .default(Text("회원가입"), action: {
                        self.showEmailSignupView = true
                }))
            }

        }
        
        
    }
    
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


struct KakaoLoginButton: UIViewRepresentable {

    
    @EnvironmentObject var login: LogIn
    @Environment(\.showLoginView) var showLoginView
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIButton {
        
        let kakaoLoginButton = UIButton()
        kakaoLoginButton.setImage(UIImage(named: "kakaoLoginButton"), for: .normal)
        kakaoLoginButton.addTarget(context.coordinator, action: #selector(context.coordinator.login(_:)), for: .touchUpInside)
        return kakaoLoginButton
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) {
        
    }
    
    class Coordinator: NSObject {
        
        var button: KakaoLoginButton
        
        init(_ button: KakaoLoginButton) {
            self.button = button
        }
        
        @objc func login(_ sender: UIButton){
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
                                    
                                    
                                    let params = [
                                        "id" : myKakaoId.description,
                                        "idType" : "KAKAO",
                                        "email": "NULL",
                                        "password": "NULL"
                                    ]
                                    
                                    DispatchQueue.main.async {
                                        self.button.login.kakaoId = myKakaoId.description
                                        
                                            requestLogIn(params: params, finished: { result in
                                                
                                                
                                        
                                                switch result.statusCode {
                                                case "200" :
                                                    self.button.login.isLoggedIn = true
                                                    handleLogInResult(result)
                                                    
                                                    
                                                    break
                                                    
                                                    
                                                case "201" :
                                                    self.button.login.showLoginAlert = true
                                                    break
                                                    
                                               
                                                default:
                                                    break
                                                }
                                                
                                            })
                                    }
                                }
                            }
                        }
                    })
                    
                }
            })
        }
    }
    
}


struct NaverLoginButton: UIViewRepresentable {
    
    
    @Environment(\.showLoginView) var showLoginView
    @EnvironmentObject var login: LogIn
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    
    func makeUIView(context: Context) -> UIButton {
        let naverLoginButton = UIButton()
            
        naverLoginButton.addTarget(context.coordinator, action: #selector(Coordinator.login(_:)), for: .touchUpInside)
        
        
        naverLoginButton.setImage(UIImage(named: "naverLoginButton"), for: .normal)
        
        
        return naverLoginButton
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) {
        
    }
    
    class Coordinator: NSObject, NaverThirdPartyLoginConnectionDelegate {
       
        var button : NaverLoginButton
        
        init(_ button: NaverLoginButton){
            
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
                            
                            
                            
                            
                            let params = [
                                "id" : naverId,
                                "idType" : "NAVER",
                                "email": nil,
                                "password": nil
                            ] 
                            
                            DispatchQueue.main.async {
                                    self.button.login.naverId = naverId
                                
                                    requestLogIn(params: params, finished: { result in
                                        
                                        
                                
                                        switch result.statusCode {
                                        case "200" :
                                            self.button.login.isLoggedIn = true
                                            handleLogInResult(result)

                                            break
                                            
                                            
                                        case "201" :
                                            self.button.login.showLoginAlert = true
                                            break
                                            
                                        default:
                                            break
                                        }
                                        
                                    })
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

struct FacebookLoginButton: UIViewRepresentable {
   
    
    
    
    @Environment(\.showLoginView) var showLoginView
    @EnvironmentObject var login: LogIn
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIButton {
        
        let facebookLoginButton = UIButton()
        facebookLoginButton.setImage(UIImage(named: "facebookLoginButton"), for: .normal)
        facebookLoginButton.addTarget(context.coordinator, action: #selector(Coordinator.handleLogin(_:)), for: .touchUpInside)
        return facebookLoginButton
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) {
    }
    
    class Coordinator: NSObject {
        
        
        var button: FacebookLoginButton
        
        init(_ button: FacebookLoginButton){
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
                            
                            
                            if let facebookId = fbDetails["id"] as? String{
                                
                                
                                
                                let params = [
                                    "id" : facebookId,
                                    "idType" : "FACEBOOK",
                                    "email": nil,
                                    "password": nil
                                ]
                                
                                DispatchQueue.main.async {
                                    
                                    self.button.login.facebookId = facebookId
                                    
                                        requestLogIn(params: params, finished: { result in
                                            
                                            
                                    
                                            switch result.statusCode {
                                            case "200" :
                                                self.button.login.isLoggedIn = true
                                                handleLogInResult(result)
                                                
                                                
                                                break
                                                
                                                
                                            case "201" :
                                                self.button.login.showLoginAlert = true
                                                break
                                                
                                            
                                                
                                            default:
                                                break
                                            }
                                            
                                        })
                                }
                            }
                        }
                    })
                }
            }

        }
        
        
    }
}
