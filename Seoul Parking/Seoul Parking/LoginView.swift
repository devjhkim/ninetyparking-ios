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
    @State var showSignupView = false
    
    @State var loginResult = LoginResult()
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.showLoginView) var showLoginView
    
    
    init() {
        
        //UINavigationBar.appearance().backgroundColor = .white
        //UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "HelveticaNeue", size: 30)!]
        //UINavigationBar.appearance().shadowImage = UIImage()
        //UINavigationBar.appearance().isTranslucent = false
        

    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                NavigationLink(destination: EmailLoginView().environment(\.showLoginView, self.showLoginView), isActive: self.$showEmailLoginView){
                    Button(action: {
                        self.showEmailLoginView = true
                    }){
                        Image("emailLoginButton")
                            
                    }
                }
                
                
                
                
                NavigationLink(destination: SignupView(loginResult: self.$loginResult), isActive: self.$showSignupView){
                    Button(action: {
                        self.showSignupView.toggle()
                    }){
                        EmptyView()
                    }
                }.hidden()
                
                
                KakaoLoginButton(loginResult: self.$loginResult)
                    .frame(width: 200, height: 30)
                    .padding(.top, 30)
                    
                
                NaverLoginButton(loginResult: self.$loginResult)   
                    .frame(width: 200, height: 30)
                    .padding(.top, 30)
                    
                
                FacebookLoginButton(loginResult: self.$loginResult)
                    .frame(width: 200, height: 30)
                    .padding(.top, 30)
                
                HStack{
                    Text("회원이 아니신가요?")
                        .font(.system(size: 14))
                    
                    Text("먼저 회원 가입해주세요.")
                        .underline()
                        .font(.system(size: 14, weight: .bold))
                        .padding(.leading, 5)
                    
                }
                .frame(width: 300, height: 30)
                .padding(.top, 30)
                .onTapGesture {
                    self.showSignupView = true
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitle(Text("로그인 해주세요"))
            .alert(isPresented: self.$loginResult.showAlert){
                Alert(title: Text("미가입 회원"), message: Text("존재하지 않는 ID입니다. 먼저 회원 가입을 해야 합니다."),
                      primaryButton: .cancel(Text("취소"), action: {}),
                      secondaryButton: .default(Text("회원가입"), action: {
                        self.showSignupView = true
                }))
            }

        }
        
        
    }
    
}

struct LoginButtonsView: View {
    @State var showEmailLoginView = false
    @State var loginResult = LoginResult()
    @Environment(\.showLoginView) var showLoginView
    var body: some View {
        VStack {
            
            NavigationLink(destination: EmailLoginView().environment(\.showLoginView, self.showLoginView), isActive: self.$showEmailLoginView){
                Button(action: {
                    self.showEmailLoginView = true
                }){
                    Image("emailLoginButton")
                        
                }
            }
            
            
            
            
            KakaoLoginButton(loginResult: self.$loginResult)
                .frame(width: 200, height: 30)
                .padding(.top, 30)
                
            
            NaverLoginButton(loginResult: self.$loginResult)
                .frame(width: 200, height: 30)
                .padding(.top, 30)
                
            
            FacebookLoginButton(loginResult: self.$loginResult)
                .frame(width: 200, height: 30)
                .padding(.top, 30)
            
        }
    }
    
    
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


struct KakaoLoginButton: UIViewRepresentable {

    typealias UIViewType = UIButton
    
    @Environment(\.showLoginView) var showLoginView
    @Binding var loginResult: LoginResult
    
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
                                    self.button.loginResult.kakaoId = myKakaoId.description
                                    
                                    let params = [
                                        "id" : myKakaoId.description,
                                        "idType" : "KAKAO",
                                        "email": nil,
                                        "password": nil
                                    ]
                                    
                                    DispatchQueue.main.async {
                                            requestLogIn(params: params, finished: { result in
                                                
                                                
                                        
                                                switch result.statusCode {
                                                case "200" :
                                                    self.button.loginResult.showAlert = false
                                                    handleLogInResult(result)
                                                    self.button.showLoginView?.wrappedValue = false
                                                    
                                                    break
                                                    
                                                    
                                                case "201" :
                                                    self.button.loginResult.showAlert = true
                                                    break
                                                    
                                                case "202" :
                                                    self.button.loginResult.showAlert = true
                                                    break
                                                    
                                                default:
                                                    break
                                                }
                                                self.button.loginResult.kakaoId = myKakaoId
                                                self.button.loginResult.statusCode = result.statusCode
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
    
    @Binding var loginResult: LoginResult
    @Environment(\.showLoginView) var showLoginView
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    typealias UIViewType = UIButton
    
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
                                    requestLogIn(params: params, finished: { result in
                                        print(result)
                                        
                                
                                        switch result.statusCode {
                                        case "200" :
                                            self.button.loginResult.showAlert = false
                                            handleLogInResult(result)
                                            self.button.showLoginView?.wrappedValue = false
                                            break
                                            
                                            
                                        case "201" :
                                            self.button.loginResult.showAlert = true
                                            break
                                            
                                        case "202" :
                                            self.button.loginResult.showAlert = true
                                            break
                                            
                                        default:
                                            break
                                        }
                                        self.button.loginResult.naverId = naverId
                                        self.button.loginResult.statusCode = result.statusCode
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
   
    
    //typealias UIViewType = UIButton
    @Binding var loginResult: LoginResult
    @Environment(\.showLoginView) var showLoginView
    
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIButton {
//        let facebookLoginButton = FBLoginButton()
//        facebookLoginButton.permissions = ["public_profile", "email"]
//        facebookLoginButton.delegate = context.coordinator
//
        
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
                            print(fbDetails)
                            
                            if let facebookId = fbDetails["id"] as? String{
                                let params = [
                                    "id" : facebookId,
                                    "idType" : "FACEBOOK",
                                    "email": nil,
                                    "password": nil
                                ]
                                
                                DispatchQueue.main.async {
                                        requestLogIn(params: params, finished: { result in
                                            
                                            
                                    
                                            switch result.statusCode {
                                            case "200" :
                                                self.button.loginResult.showAlert = false
                                                handleLogInResult(result)
                                                self.button.showLoginView?.wrappedValue = false
                                                
                                                break
                                                
                                                
                                            case "201" :
                                                self.button.loginResult.showAlert = true
                                                break
                                                
                                            case "202" :
                                                self.button.loginResult.showAlert = true
                                                break
                                                
                                            default:
                                                break
                                            }
                                            self.button.loginResult.facebookId = facebookId
                                            self.button.loginResult.statusCode = result.statusCode
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
