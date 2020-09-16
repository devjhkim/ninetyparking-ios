//
//  NameModificationView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 2020/09/16.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct NameModificationView: View {
    
    @State var newName = ""
    @State var showNameMinAlert = false
    @State var showNameChangedAlert = false
    @State var showAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store: Store
    
    var body: some View {
        ZStack{
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack {
                    Text("이름")
                        .foregroundColor(Color.black)
                    TextField("", text: $newName)
                        .foregroundColor(.black)
                        .alert(isPresented: self.$showNameMinAlert){
                            Alert(title: Text(""), message: Text("이름은 2글자 이상 이어야 합니다."), dismissButton: .default(Text("확인"), action: {self.showNameMinAlert = false}))
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
                    
                    Button(action: { self.changeName()}){
                        Image("changeButton")
                    }
                    .alert(isPresented:self.$showNameChangedAlert){
                        Alert(title: Text(""), message: Text("이름이 변경 되었습니다."), dismissButton: .default(Text("확인"), action: {self.presentationMode.wrappedValue.dismiss()}))
                    }
                    
                    Spacer()
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .onAppear(perform: {
                self.newName = self.store.user.name
            })
            .navigationBarTitle("이름변경")
        }
    }
    
    func changeName() {
        if self.newName == self.store.user.name{
            return
        }
        
        if self.newName.count < NAME_LENGTH.MIN {
            self.showNameMinAlert = true
            return
        }
        
        
        guard let url = URL(string: REST_API.USER.UPDATE.NAME) else {return}
        
        let params = [
            "userUniqueId": self.store.user.userUniqueId,
            "newName": self.newName
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
                                UserDefaults.standard.set(self.newName, forKey: "userName")
                                self.store.user.name = self.newName
                                
                                self.showNameChangedAlert = true
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

struct NameModificationView_Previews: PreviewProvider {
    static var previews: some View {
        NameModificationView()
    }
}
