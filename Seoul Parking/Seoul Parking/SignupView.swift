//
//  SignupView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 7/21/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct SignupView: View {
    @Binding var loginResult: LoginResult
    @State var name = ""
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var showNameMinAlert = false
    @State var showPasswordLengthAlert = false
    @State var showPasswordNotMatchingAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            VStack {
                TextField("이름", text: self.$name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .alert(isPresented: self.$showNameMinAlert){
                        Alert(title: Text(""), message: Text("이름은 2글자 이상 이어야 합니다."), dismissButton: .default(Text("확인"), action: {self.showNameMinAlert.toggle()}))
                    }
                
                TextField("이메일 주소", text: self.$email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .padding(.top, 30)
                
                SecureField("비밀번호", text: self.$password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 30)
                    .alert(isPresented: self.$showPasswordLengthAlert){
                        Alert(title: Text(""), message: Text("비밀번호 길이는 4 ~ 8글자 입니다."), dismissButton: .default(Text("확인")))
                    }
                
                SecureField("비밀번호 확인", text: self.$confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 30)
                    .alert(isPresented: self.$showPasswordNotMatchingAlert){
                        Alert(title: Text(""), message: Text("비밀번호가 일치하지 않습니다."), dismissButton: .default(Text("확인")))
                    }
                
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Text("취소")
                    }

                    Button(action: {
                        self.signUp()
                    }){
                        Text("회원가입")
                    }
                }
                
                Spacer()
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .navigationBarTitle("회원가입", displayMode: .inline)
           

        }
        
    }
    
    private func signUp(){
        if self.name.count < NAME_LENGTH.MIN {
            self.showNameMinAlert.toggle()
            return
        }
        
        if self.password.count < PASSWORD_LENGTH.MIN && self.password.count > PASSWORD_LENGTH.MAX {
            self.showPasswordLengthAlert = true
            return
        }
        
        if self.password != self.confirmPassword {
            self.showPasswordNotMatchingAlert = true
            return
        }
        
        let params = [
            "name" : self.name,
            "kakaoId": self.loginResult.kakaoId.count > 0 ? self.loginResult.kakaoId : nil,
            "naverId": self.loginResult.naverId.count > 0 ? self.loginResult.naverId : nil,
            "facebookId": self.loginResult.facebookId.count > 0 ? self.loginResult.facebookId : nil,
            "email": self.email,
            "password": self.password,
            "phoneNumberr": ""
        ]
        
        do{
            let jsonParams = try JSONSerialization.data(withJSONObject: params, options: [])
            if let url = URL(string: REST_API.USER.SIGN_UP) {
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
                            let json = try JSONSerialization.jsonObject(with: rawData, options: []) as? [String:Any]
                            
                            if let json = json {
                                print(json)
                                
//                                guard let obj = json["response"] as? [String:Any] else { return }
//                                guard let naverId = obj["id"] as? String else { return }
//
                                
                                
                    
                                
                                DispatchQueue.main.async {
                                    UserDefaults.standard.set("", forKey: "isLoggedIn")
                                    UserDefaults.standard.set("", forKey: "userUniqueId")
                                }
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
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(loginResult: .constant(LoginResult()))
    }
}
