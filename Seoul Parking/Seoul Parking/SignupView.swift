//
//  SignupView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 7/21/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct SignupView: View {
    @State var name = ""
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            TextField("이름", text: self.$name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("이메일 주소", text: self.$email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .padding(.top, 30)
            
            SecureField("비밀번호", text: self.$password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.top, 30)
            
            SecureField("비밀번호 확인", text: self.$confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.top, 30)
            
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Text("취소")
                }

                Button(action: {}){
                    Text("회원가입")
                }
            }
            
            Spacer()
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
