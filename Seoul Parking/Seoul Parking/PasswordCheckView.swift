//
//  PasswordCheckView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 2020/10/19.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct PasswordCheckView: View {
    
    @Binding var auxViewType: AuxViewType
    @State var password = ""
    @EnvironmentObject var store: Store
    
    var body: some View {
        ZStack{
            GeometryReader(){ reader in
                EmptyView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color.gray.opacity(0.3))
            
            ZStack{
                Color.init( red: 229, green: 229, blue: 234)
                    .frame(width: 300, height: 200, alignment: Alignment.center)
                    .cornerRadius(10)
                
                VStack{
                    Spacer()
                    
                    Text("비밀번호 확인")
                        .bold()
                        .font(.system(size: 16))
                        .padding(.top, 5)
                    
                    Spacer()
                    
                    Text("본인확인을 위해 비밀번호를 입력해야 합니다.")
                        .font(.system(size: 14))
                        .padding(.top, 5)

                    Spacer()
                    
                    SecureField("비밀번호", text:self.$password)
                        .padding([.leading, .trailing], 16)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.gray)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                    
                    Spacer()
                    
                    HStack{
                        Spacer()
                        
                        Button(action: {self.auxViewType.showPasswordCheckAlert = false}){
                            Text("취소")
                                .foregroundColor(Color.red)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if self.password.isEmpty{
                                return
                            }
                            
                            self.auxViewType.showPasswordCheckAlert = false
                            self.checkPasswod()
                            
                        }){
                            Text("확인")
                                .foregroundColor(Color.blue)
                        }
                        
                        Spacer()
                    }
                    
                    
                    Spacer()
                }
                .frame(width: 290, height: 190, alignment: Alignment.center)
                
            }
            
        }
        
    }
    
    private func checkPasswod(){
        
        
        
        
        guard let url = URL(string: REST_API.USER.CHECK_PASSWORD) else {return}
        
        let params = [
            "userUniqueId": UserInfo.getInstance.uniqueId,
            "currentPassword": self.password
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
                
                
                do {
                    if let rawData = data {
                        let json = try JSONSerialization.jsonObject(with: rawData, options: []) as? [String:Any]
                        
                        if let json = json {
                            guard let statusCode = json["statusCode"] as? String else {return}
                            
                            switch statusCode {
                            case "200":
                                
                                self.auxViewType.showSettingsView = true
                                self.store.user.password = self.password
                                break
                                
                            case "201":
                                self.auxViewType.showWrongPasswordAlert = true
                                break
                                
                            default:
                                break
                            }
                        }
                    }
                }catch {
                    fatalError(error.localizedDescription)
                }
                
            }.resume()
        }catch{
            fatalError(error.localizedDescription)
        }
    }
}

struct PasswordCheckView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordCheckView(auxViewType: .constant(AuxViewType()))
    }
}
