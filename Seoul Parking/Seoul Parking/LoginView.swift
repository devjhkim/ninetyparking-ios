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

// Swift // // Add this to the header of your file, e.g. in ViewController.swift import FBSDKLoginKit // Add this to the body class ViewController: UIViewController { override func viewDidLoad() { super.viewDidLoad() let loginButton = FBLoginButton() loginButton.center = view.center view.addSubview(loginButton) } }


struct LoginView: View {
    @State var showEmailLoginView = false
    @State var kakaoId: String = ""
    @State var showAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                
                //NavigationLink(destination: EmailLoginView(), isActive: self.$showEmailLoginView){
                NavigationLink(destination: SignupView(), isActive: self.$showEmailLoginView){
                    Button(action: {
                        self.showEmailLoginView.toggle()
                    }){
                        Text("Log in with Email")
                    }
                }
                
                
                KakaoLoginButton(kakaoId: self.$kakaoId)
                    .frame(width: 200, height: 30)
                    .padding(.top, 30)
                
                NaverLoginButton()
                    .frame(width: 200, height: 30)
                    .padding(.top, 30)
                    
                
                FacebookLoginButton()
                    .frame(width: 200, height: 30)
                    .padding(.top, 30)
            }
            .navigationBarTitle("로그인", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }){
                Text("닫기")
            } )
            .alert(isPresented: self.$showAlert){
                Alert(title: Text("미가입 회원"), message: Text("존재하지 않는 ID입니다. 먼저 회워 가입을 해야 합니다."), primaryButton: .cancel(Text("취소"), action: {}), secondaryButton: .default(Text("확인"), action: {
                    
                }))
            }
        
        }

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(kakaoId: "")
    }
}


struct KakaoLoginButton: UIViewRepresentable {

    
    
    @Binding var kakaoId: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> KOLoginButton {
        
        let kakaoLoginButton = KOLoginButton()
        kakaoLoginButton.addTarget(context.coordinator, action: #selector(Coordinator.login(_:)), for: .touchUpInside)
        return kakaoLoginButton
    }
    
    func updateUIView(_ uiView: KOLoginButton, context: Context) {
        
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
                            print(me! as KOUserMe)
                            
                            if let myinfo = me as KOUserMe? {
                                print(myinfo.id as Any)
                                
                                if let myKakaoId = myinfo.id {
                                    self.button.kakaoId = myKakaoId.description
                                    
                                    let params = [
                                        "id" : myKakaoId.description,
                                        "idType" : "KAKAO",
                                        "email": nil,
                                        "password": nil
                                    ]
                                    
                                    do{
                                        let jsonParams = try JSONSerialization.data(withJSONObject: params, options: [])
                                        if let url = URL(string: REST_API.USER.LOG_IN) {
                                            var request = URLRequest(url: url)
                                            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                            request.httpMethod = "POST"
                                            request.httpBody = jsonParams
                                            
                                            URLSession(configuration: .default).dataTask(with: request){ (data, response, error) in
                                                if data == nil {
                                                    return
                                                }
                                                
                                                do{
                                                    if let rawData = data {
                                                        let login = try JSONDecoder().decode(LoginData.self, from: rawData)
                                                        
                                                        
                                                        
                                                        DispatchQueue.main.async {
                                                           
                                                        
                                                            

                                                            print(login)

                                                        }

                                                   }

                                               }catch{
                                                   fatalError(error.localizedDescription)
                                               }
                                            }.resume()
                                        }
                                        
                                    }catch{
                                        
                                    }

                                }
                                
                                print(self.button.kakaoId)
                                
                                
                                
                            }
                        }
                    })
                    
                }
            })
        }
    }
    
}


struct NaverLoginButton: UIViewRepresentable {
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    typealias UIViewType = UIButton
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    
    func makeUIView(context: Context) -> UIButton {
        let naverLoginButton = UIButton()
            
        naverLoginButton.addTarget(context.coordinator, action: #selector(Coordinator.login(_:)), for: .touchUpInside)
        naverLoginButton.setImage(UIImage(named: "naverLogin"), for: .normal)
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
                            
                            print(naverId)
                            
                            
                            let params = [
                                "id" : naverId,
                                "idType" : "NAVER",
                                "email": nil,
                                "password": nil
                            ] 
                            
                            requestLogIn(params: params, finished: { result in
                                print(result)
                                
                                if result.statusCode == "200" {
                                    
                                }
                                
                                switch result.statusCode {
                                case "200" :
                                    
                                    break
                                    
                                    
                                case "201" :
                                    
                                    break
                                    
                                case "202" :
                                    
                                    break
                                    
                                default:
                                    break
                                }
                            })
                            
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
    
    
    typealias UIViewType = FBButton
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> FBButton {
        let facebookLoginButton = FBLoginButton()
        facebookLoginButton.permissions = ["public_profile", "email"]
        facebookLoginButton.delegate = context.coordinator
        
        return facebookLoginButton
    }
    
    func updateUIView(_ uiView: FBButton, context: Context) {
        
    }
    
    class Coordinator: NSObject, LoginButtonDelegate {
        
        
        var button: FacebookLoginButton
        
        init(_ button: FacebookLoginButton){
            self.button = button
        }
        
        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            if error != nil {
               // print(error?.localizedDescription)
               return
            }
            
            let facebookId = AccessToken.current?.userID
            print(facebookId)
        }
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            
        }
    }
}
