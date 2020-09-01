//
//  SignupView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 9/1/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct SignupView: View {
    @State var showEmailLoginView = false
    @State var showSignupView = false
    
    @State var loginResult = LoginResult()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            Color.white
                .edgesIgnoringSafeArea(.all)
           VStack {
                
                NavigationLink(destination: EmailSignupView(loginResult: self.$loginResult), isActive: self.$showSignupView){
                    Button(action: {
                        self.showSignupView.toggle()
                    }){
                        Image("emailSignupButton")
                        
                    }
                }
                
                KakaoSignupButton()
                    .frame(width: 200, height: 30)
                    .padding(.top, 30)
                
                
                NaverSignupButton()
                    .frame(width: 200, height: 30)
                    .padding(.top, 30)
                
                
                FacebookSignupButton()
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
                                    
                                    
                                    DispatchQueue.main.async {
                                            
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

struct NaverSignupButton: UIViewRepresentable {
    func makeUIView(context: Context) -> UIButton {
        let naverSignupButton = UIButton()
        naverSignupButton.setImage(UIImage(named: "naverSignupButton"), for: .normal)
        return naverSignupButton
        
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject {
        
    }
}

struct FacebookSignupButton: UIViewRepresentable {
    func makeUIView(context: Context) -> UIButton {
        let facebookSignupButton = UIButton()
        facebookSignupButton.setImage(UIImage(named: "facebookSignupButton"), for: .normal)
        return facebookSignupButton
        
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject {
        
    }
}
