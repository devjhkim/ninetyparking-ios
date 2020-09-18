//
//  PlateNumberModificationView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 2020/09/16.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct PlateNumberModificationView: View {
    
    @State var newPlateNumber = ""
    @State var showAlert = false
    @State var showPlateNumberMaxAlert = false
    @State var showAddPlateNumberAlert = false
    @State var showPlateNumbersUpdatedAlert = false
    
    @EnvironmentObject var store: Store
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    Text("차량번호")
                        .foregroundColor(Color.black)
                    TextField("", text: self.$newPlateNumber)
                        .foregroundColor(.black)
                    
                    
                    Button(action: {
                        if !self.newPlateNumber.isEmpty {
                            if self.store.user.plateNumbers.count < MAX_PLATE_NUMBERS {
                                if !self.store.user.plateNumbers.contains(self.newPlateNumber){
                                    self.store.user.plateNumbers.append(self.newPlateNumber)
                                }
                            } else {
                                self.showPlateNumberMaxAlert = true
                            }
                            
                        }
                    }) {
                        
                        Text("추가")
                        
                    }
                    
                }
                .padding()
                .background(Capsule().stroke(Color.black, lineWidth: 2))
                
                    
                .alert(isPresented: self.$showPlateNumberMaxAlert, content: {
                    Alert(title: Text(""), message: Text("차량은 3대 까지 등록 가능합니다."), dismissButton: .default(Text("확인")))
                })
                
                List{
                    ForEach(Array(zip(self.store.user.plateNumbers.indices, self.store.user.plateNumbers)), id: \.0) { index, number in
                        HStack{
                            Text(number)
                                .foregroundColor(Color.black)
                            Spacer()
                            
                            Button(action: {
                                self.store.user.plateNumbers.remove(at: index)
                            }){
                            
                                Text("삭제")
                                    .foregroundColor(.red)
                            }
                        }
                        .listRowBackground(Color.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .listRowInsets(EdgeInsets())
                        .background(Color.white)
                        
                    }
                    .onDelete(perform: delete(at:))
                    
                }
                .alert(isPresented: self.$showAddPlateNumberAlert, content: {
                    Alert(title: Text(""), message: Text("차량번호를 입력해주세요."), dismissButton: .default(Text("확인")))
                })
                
                HStack{
                    Spacer()
                    
                    Button(action:{self.presentationMode.wrappedValue.dismiss()}){
                        Image("cancelButton")
                    }
                        .alert(isPresented: self.$showAlert){
                            Alert(title: Text(""), message: Text("서버에러"), dismissButton: .default(Text("확인"), action: {self.showAlert = false}))
                        }
                        
                    Spacer()
                    
                    Button(action: { self.updatePlateNumbers()}){
                        Image("changeButton")
                    }
                    .alert(isPresented:self.$showPlateNumbersUpdatedAlert){
                        Alert(title: Text(""), message: Text("차량번호가 변경 되었습니다."), dismissButton: .default(Text("확인"), action: {self.presentationMode.wrappedValue.dismiss()}))
                    }
                    
                    Spacer()
                }
                .padding()
                
                
            }
            .padding()
        }
        
        
    }
    
    
    func delete(at offsets: IndexSet) {
        self.store.user.plateNumbers.remove(atOffsets: offsets)
    }
    
    func updatePlateNumbers() {
        guard let url = URL(string: REST_API.USER.UPDATE.PLATE_NUMBERS) else {return}

        let params = [
            "userUniqueId" : UserInfo.getInstance.uniqueId,
            "newPlateNumbers" : self.store.user.plateNumbers
        ] as [String : Any]
        
        do{
            let jsonParams = try JSONSerialization.data(withJSONObject: params, options: [])
            var request = URLRequest(url: url)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jsonParams
            URLSession.shared.dataTask(with: request) {(data, response, error) in
                
            }.resume()
        }catch{
            fatalError(error.localizedDescription)
        }
    }
    
}

struct PlateNumberModificationView_Previews: PreviewProvider {
    static var previews: some View {
        PlateNumberModificationView()
    }
}
