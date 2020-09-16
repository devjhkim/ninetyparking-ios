//
//  EmailModificationView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 2020/09/16.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct EmailModificationView: View {
    @State var newEmail = ""
    @State var showInvalidEmailAlert = false
    @State var showEmailChangedAlert = false
    @State var showTakenEmailAlert = false
    @State var showAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store: Store
    
    var body: some View {
        ZStack{
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack {
                    Text("이메일 주소")
                        .foregroundColor(Color.black)
                    TextField("", text: $newEmail)
                        .foregroundColor(.black)
                        .alert(isPresented: self.$showInvalidEmailAlert){
                            Alert(title: Text(""), message: Text("올바른 이메일 주소 형식이 아닙니다."), dismissButton: .default(Text("확인"), action: {self.showInvalidEmailAlert = false}))
                        }
                }
                .padding()
                .background(Capsule().stroke(Color.black, lineWidth: 2))
                
                
                HStack{
                    Spacer()
                    
                    Button(action:{self.presentationMode.wrappedValue.dismiss()}){
                        Image("cancelButton")
                    }
                        .alert(isPresented: self.$showAlert){
                            Alert(title: Text(""), message: Text("서버에러"), dismissButton: .default(Text("확인"), action: {self.showAlert = false}))
                        }
                        
                    Spacer()
                        .alert(isPresented: self.$showTakenEmailAlert){
                            Alert(title: Text(""), message: Text("이미 사용중인 이메일 주소 입니다."), dismissButton: .default(Text("확인"), action: {self.showAlert = false}))
                        }
                    
                    Button(action: { self.changeEmail()}){
                        Image("changeButton")
                    }
                    .alert(isPresented:self.$showEmailChangedAlert){
                        Alert(title: Text(""), message: Text("이메일 주소가 변경 되었습니다."), dismissButton: .default(Text("확인"), action: {self.presentationMode.wrappedValue.dismiss()}))
                    }
                    
                    Spacer()
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .onAppear(perform: {
                self.newEmail = self.store.user.email
            })
            .navigationBarTitle("이메일 주소 변경")
        }
    }
    
    func changeEmail() {
        if self.newEmail == self.store.user.email{
            return
        }
        
        if !isValidEmail(email: self.newEmail){
            self.showInvalidEmailAlert = true
            return
        }
        
        
        guard let url = URL(string: REST_API.USER.UPDATE.EMAIL) else {return}
        
        let params = [
            "userUniqueId": self.store.user.userUniqueId,
            "newEmail": self.newEmail
        ]
        
        
        
        do{
            let jsonParams = try JSONSerialization.data(withJSONObject: params, options: [])
            var request = URLRequest(url: url)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jsonParams
            URLSession.shared.dataTask(with: request) {(data, response, error) in
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
                                UserDefaults.standard.set(self.newEmail, forKey: "email")
                                self.store.user.email = self.newEmail
                                
                                self.showEmailChangedAlert = true
                                break
                                
                            case "201":
                                self.showTakenEmailAlert = true
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
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

struct EmailModificationView_Previews: PreviewProvider {
    static var previews: some View {
        EmailModificationView()
    }
}
