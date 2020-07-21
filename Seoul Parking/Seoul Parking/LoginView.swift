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

struct LoginView: View {
    
   @State var kakaoId: String = ""
    
    var body: some View {
        
        VStack {
            
            
            KakaoLoginButton(kakaoId: self.$kakaoId)
                .frame(width: 200, height: 30)
            
            NaverLoginButton()
                .frame(width: 200, height: 30)
                .padding(.top, 30)
            
            
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
            
            
            print(tokenType)
            print(accessToken)
            
            
            let urlStr = "https://openapi.naver.com/v1/nid/me"
            let url = URL(string: urlStr)!
           
           let authorization = "\(tokenType) \(accessToken)"
           
//           let req = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
//
//           req.responseJSON { response in
//             guard let result = response.result.value as? [String: Any] else { return }
//             guard let object = result["response"] as? [String: Any] else { return }
//             guard let name = object["name"] as? String else { return }
//             guard let email = object["email"] as? String else { return }
//             guard let nickname = object["nickname"] as? String else { return }
//
//             self.nameLabel.text = "\(name)"
//             self.emailLabel.text = "\(email)"
//             self.nicknameLabel.text = "\(nickname)"
//           }
         }

        
        func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
            getNaverInfo()
        }
       
        func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
           
        }
       
        func oauth20ConnectionDidFinishDeleteToken() {
           
        }
       
        func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
           
        }
               
    }
    
    
    
    
}
