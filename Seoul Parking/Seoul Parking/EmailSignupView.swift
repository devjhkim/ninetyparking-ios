//
//  SignupView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 7/21/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct EmailSignupView: View {
    @Binding var loginResult: LoginResult
    @State var name = ""
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var showPassword = false
    @State var showConfirmPassword = false
    @State var showNameMinAlert = false
    @State var showEmailAlert = false
    @State var showPasswordLengthAlert = false
    @State var showPasswordNotMatchingAlert = false
    @State var showAlert = false
    @State var alertType = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        ZStack {
            Color.white
            
            VStack {
                HStack {
                    Text("이름")
                        .foregroundColor(Color.black)
                    TextField("", text: $name)
                        .foregroundColor(.black)
                        .alert(isPresented: self.$showNameMinAlert){
                            Alert(title: Text(""), message: Text("이름은 2글자 이상 이어야 합니다."), dismissButton: .default(Text("확인"), action: {self.showNameMinAlert = false}))
                    }
                }
                .padding()
                .background(Capsule().stroke(Color.black, lineWidth: 2))
                
                HStack{
                    Text("이메일 주소")
                        .foregroundColor(Color.black)
                    TextField("", text: self.$email)
                        .foregroundColor(.black)
                        .keyboardType(.emailAddress)
                        
                        .alert(isPresented: self.$showEmailAlert){
                            Alert(title: Text(""), message: Text("유효한 이메일 주소 형식이 아닙니다."), dismissButton: .default(Text("확인"), action: {self.showEmailAlert = false}))
                    }
                    
                }
                .padding()
                .background(Capsule().stroke(Color.black, lineWidth: 2))
                
                HStack {
                    Text("비밀번호")
                        .foregroundColor(Color.black)
                    //                        if showPassword {
                    //                            TextField("", text: $password)
                    //                                .foregroundColor(.black)
                    //                        } else {
                    //                            SecureField("", text: $password)
                    //                                .textContentType(.newPassword)
                    //                                .foregroundColor(.black)
                    //                        }
                    
                    SecureField("", text: $password)
                        .textContentType(.newPassword)
                        .foregroundColor(.black)
                    
                    Button(action: {self.showPassword.toggle()}) {
                        
                        Image(systemName: "eye")
                            .renderingMode(.template)
                            .foregroundColor(Color.black)
                        
                    }
                }
                .padding()
                .background(Capsule().stroke(Color.black, lineWidth: 2))
                .alert(isPresented: self.$showPasswordLengthAlert){
                    Alert(title: Text(""), message: Text("비밀번호 길이는 4 ~ 8글자 입니다."), dismissButton: .default(Text("확인"), action: {self.showPasswordLengthAlert = false}))
                }
                
                HStack{
                    Text("비밀번호 확인")
                        .foregroundColor(.black)
                    //                        if showConfirmPassword {
                    //                           TextField("", text: $confirmPassword)
                    //                               .foregroundColor(.black)
                    //                       } else {
                    //                           SecureField("", text: $confirmPassword)
                    //                                .textContentType(.newPassword)
                    //                               .foregroundColor(.black)
                    //                       }
                    //
                    
                    SecureField("", text: $confirmPassword)
                        .textContentType(.newPassword)
                        .foregroundColor(.black)
                    
                    Button(action: {self.showConfirmPassword.toggle()}) {
                        
                        Image(systemName: "eye")
                            .renderingMode(.template)
                            .foregroundColor(Color.black)
                        
                    }
                }
                .padding()
                .background(Capsule().stroke(Color.black, lineWidth: 2))
                .alert(isPresented: self.$showPasswordNotMatchingAlert){
                    Alert(title: Text(""), message: Text("비밀번호가 일치하지 않습니다."), dismissButton: .default(Text("확인"), action: {self.showPasswordNotMatchingAlert = false}))
                }
                
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Image("cancelButton")
                    }
                    
                    Button(action: {
                        self.signUp()
                    }){
                        Image("signupButton")
                    }
                    .padding(.leading, 50)
                }
                .padding()
                .alert(isPresented: self.$showAlert){
                    var message = ""
                    
                    switch self.alertType {
                    case "201":
                        message = "회원 가입에 실패하였습니다."
                        break
                        
                    case "202":
                        message = "이미 가입된 사용자입니다."
                        break
                        
                        
                    case "500":
                        message = "서버에러"
                        break
                        
                    default:
                        
                        break
                    }
                    
                    return Alert(title: Text(""), message: Text(message), dismissButton: .default(Text("확인"), action: {self.showAlert = false}))
                }
                
                Spacer()
                
                Spacer()
            }
            .padding()
            
            
        }
        
        
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func signUp(){
        if self.name.count < NAME_LENGTH.MIN {
            self.showNameMinAlert.toggle()
            return
        }
        
        if !isValidEmail(email: self.email){
            self.showEmailAlert.toggle()
            return
        }
        
        if self.password.count < PASSWORD_LENGTH.MIN || self.password.count > PASSWORD_LENGTH.MAX {
            self.showPasswordLengthAlert.toggle()
            return
        }
        
        if self.password != self.confirmPassword {
            self.showPasswordNotMatchingAlert.toggle()
            return
        }
        
        let name = self.name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        print(name)
        
        let params = [
            "name" : name,
            "kakaoId": self.loginResult.kakaoId.count > 0 ? self.loginResult.kakaoId : nil,
            "naverId": self.loginResult.naverId.count > 0 ? self.loginResult.naverId : nil,
            "facebookId": self.loginResult.facebookId.count > 0 ? self.loginResult.facebookId : nil,
            "email": self.email,
            "password": self.password,
            "phoneNumber": ""
        ]
        
        do{
            let jsonParams = try JSONSerialization.data(withJSONObject: params, options: [])
            if let url = URL(string: REST_API.USER.SIGN_UP) {
                var request = URLRequest(url: url)
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
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
                                guard let statusCode = json["statusCode"] as? String else {return}
                                self.alertType = statusCode
                                
                                switch statusCode {
                                case "200":
                                    guard let userUniqueId = json["userUniqueId"] as? String else {return}
                                    
                                    DispatchQueue.main.async {
                                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                        UserDefaults.standard.set(userUniqueId, forKey: "userUniqueId")
                                        UserDefaults.standard.set(name, forKey: "userName")
                                        
                                        UserInfo.getInstance.uniqueId = userUniqueId
                                        UserInfo.getInstance.name = name
                                        UserInfo.getInstance.isLoggedIn = true
                                        
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                    
                                    break
                                    
                                case "201":
                                    self.showAlert = true
                                    break
                                    
                                case "202":
                                    self.showAlert = true
                                    break
                                    
                                case "500":
                                    
                                    self.showAlert = true
                                    
                                    break
                                    
                                    
                                    
                                default:
                                    break
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

struct EmailSignupView_Previews: PreviewProvider {
    static var previews: some View {
        EmailSignupView(loginResult: .constant(LoginResult()))
    }
}
