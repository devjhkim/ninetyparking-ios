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
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            TextField("이메일 주소", text: self.$email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                
            SecureField("비밀번호", text: self.$password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.top, 30)
            
            HStack{
                Button(action: {self.presentationMode.wrappedValue.dismiss()}){
                    Text("취소")
                }
                
                Button(action: {
                    
                }){
                    Text("로그인")
                }
            }
            
            Spacer()
            
        }
    }
}

struct EmailLoginView_Previews: PreviewProvider {
    static var previews: some View {
        EmailLoginView()
    }
}
