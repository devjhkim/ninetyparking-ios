//
//  PasswordModificationView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 2020/09/17.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct PasswordModificationView: View {
    @State var newPassword = ""
    @State var confirmNewPassword = ""
    @State var showPassword = false
    @State var showConfirmPassword = false
    @State var showPasswordLengthAlert = false
    @State var showPasswordNotMatchingAlert = false
    @State var showPasswordChangedAlert = false
    
    @State var showAlert = false
    
    @EnvironmentObject var store: Store
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            HStack {
                Text("새 비밀번호")
                    .foregroundColor(Color.black)
                //                        if showPassword {
                //                            TextField("", text: $password)
                //                                .foregroundColor(.black)
                //                        } else {
                //                            SecureField("", text: $password)
                //                                .textContentType(.newPassword)
                //                                .foregroundColor(.black)
                //                        }
                
                SecureField("", text: $newPassword)
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
                Text("새 비밀번호 확인")
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
                
                SecureField("", text: $confirmNewPassword)
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
            
            HStack{
                Spacer()
                
                Button(action:{self.presentationMode.wrappedValue.dismiss()}){
                    Image("cancelButton")
                }
                    .alert(isPresented: self.$showAlert){
                        Alert(title: Text(""), message: Text("서버에러"), dismissButton: .default(Text("확인"), action: {self.showAlert = false}))
                    }
                    
                Spacer()
                
                Button(action: { self.changePassword()}){
                    Image("changeButton")
                }
                .alert(isPresented:self.$showPasswordChangedAlert){
                    Alert(title: Text(""), message: Text("비밀번호가 변경 되었습니다."), dismissButton: .default(Text("확인"), action: {self.presentationMode.wrappedValue.dismiss()}))
                }
                
                Spacer()
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
    
    func changePassword(){
        
        if self.newPassword.count < PASSWORD_LENGTH.MIN || self.newPassword.count > PASSWORD_LENGTH.MAX {
            self.showPasswordLengthAlert.toggle()
            return
        }
        
        if self.newPassword != self.confirmNewPassword {
            self.showPasswordNotMatchingAlert.toggle()
            return
        }
        
        guard let url = URL(string: REST_API.USER.UPDATE.PASSWORD) else {
            return
        }
        
        let params = [
            "userUniqueId": UserInfo.getInstance.uniqueId,
            "newPassword": self.newPassword,
            "currentPassword": self.store.user.password
        ]
        
        do{
            let jsonParams = try JSONSerialization.data(withJSONObject: params, options: [])
            var request = URLRequest(url: url)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jsonParams
            
            URLSession.shared.dataTask(with: request){(data, response, error) in
                if data == nil {
                    return
                }
                
                do{
                    if let rawData = data {
                        let json = try JSONSerialization.jsonObject(with: rawData, options: []) as? [String:Any]
                        
                        if let json = json {
                            guard let statusCode = json["statusCode"] as? String else {return}
                            
                            switch statusCode {
                            case "200":
                                self.showPasswordChangedAlert = true
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
        }catch{
            fatalError(error.localizedDescription)
        }
    }
}

struct PasswordModificationView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordModificationView()
    }
}
