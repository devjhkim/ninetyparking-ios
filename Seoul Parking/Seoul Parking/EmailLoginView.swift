//
//  EmailLoginView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 7/21/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct EmailLoginView: View {
    @State var email = ""
    @State var password = ""
    @State var showAlert = false
    @State var showEmailAlert = false
    @State var showPasswordAlert = false
    @State var showPassword = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.showLoginView) var showLoginView
    
    var body: some View {
        ZStack{
            Color.white
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            VStack{
                HStack{
                   Text("이메일 주소")
                       .foregroundColor(Color.black)
                   TextField("", text: self.$email)
                        .foregroundColor(.black)
                        .keyboardType(.emailAddress)
                        
                   
               }
               .padding()
               .background(Capsule().stroke(Color.black, lineWidth: 2))
                .alert(isPresented:self.$showEmailAlert){
                    Alert(title: Text(""), message: Text("이메일 주소를 입력하세요."), dismissButton: .default(Text("확인"), action: {self.showEmailAlert = false}))
                }
            
                
                HStack {
                    Text("비밀번호")
                        .foregroundColor(Color.black)
                    
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
                .alert(isPresented:$showPasswordAlert){
                    Alert(title: Text(""), message: Text("비밀번호를 입력하세요."), dismissButton: .default(Text("확인"), action: {self.showPasswordAlert = false}))
                }
                
                
                HStack{
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Image("cancelButton")
                    }
                    
                    
                    
                    Button(action: {
                        
                        if self.email.isEmpty {
                            self.showEmailAlert = true
                            return
                        }
                        
                        if self.password.isEmpty {
                            self.showPasswordAlert = true
                            return
                        }
                        
                        let params = [
                            "id" : nil,
                            "idType" : "EMAIL",
                            "email": nil,
                            "password": nil
                        ]
                        
                        requestLogIn(params: params, finished: { result in

                                switch result.statusCode {
                                case "200" :
                                    
                                    let userUniqueId = result.userUniqueId
                                    let name = result.name
                                    
                                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                    UserDefaults.standard.set(userUniqueId, forKey: "userUniqueId")
                                    UserDefaults.standard.set(name, forKey: "userName")
                                    
                                    UserInfo.getInstance.uniqueId = userUniqueId
                                    UserInfo.getInstance.name = name
                                    UserInfo.getInstance.isLoggedIn = true
                                    
                                    self.showLoginView?.wrappedValue = false
                                    
                                    self.presentationMode.wrappedValue.dismiss()
                                    
                                    break
                                    
                                    
                                case "201" :
                                    self.showAlert.toggle()
                                    break
                                    
                                
                                    
                                default:
                                    break
                                }
                                
                            })
                    }){
                        Image("loginButton")
                    }
                    .padding(.leading, 50)
                }
                .padding()
                .alert(isPresented: self.$showAlert){
                    Alert(title: Text(""), message: Text("미가입 사용자 이거나 비밀번호가 틀렸습니다."), dismissButton: .default(Text("확인"), action: {self.showAlert = false}))
                }
                
                Spacer()
            }
            .padding()
            
          
        }
    }
}

struct EmailLoginView_Previews: PreviewProvider {
    static var previews: some View {
        EmailLoginView()
    }
}
