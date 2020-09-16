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
    @State var plateNumbers = [String]()
    @State var showPlateNumberMaxAlert = false
    @State var showAddPlateNumberAlert = false
    
    var body: some View {
        VStack{
            HStack{
                Text("차량번호")
                    .foregroundColor(Color.black)
                TextField("", text: self.$newPlateNumber)
                    .foregroundColor(.black)
                
                
                Button(action: {
                    if !self.newPlateNumber.isEmpty {
                        if self.plateNumbers.count < MAX_PLATE_NUMBERS {
                            if !self.plateNumbers.contains(self.newPlateNumber){
                                self.plateNumbers.append(self.newPlateNumber)
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
                ForEach(Array(zip(self.plateNumbers.indices, self.plateNumbers)), id: \.0) { index, number in
                    HStack{
                        Text(number)
                        
                        Spacer()
                        
                        Button(action: {
                            self.plateNumbers.remove(at: index)
                        }){
                        
                            Text("삭제")
                        }
                    }
                    
                }
                .onDelete(perform: delete(at:))
                
            }
            .alert(isPresented: self.$showAddPlateNumberAlert, content: {
                Alert(title: Text(""), message: Text("차량번호를 입력해주세요."), dismissButton: .default(Text("확인")))
            })
        }
    }
    
    
    func delete(at offsets: IndexSet) {
        self.plateNumbers.remove(atOffsets: offsets)
    }
    
}

struct PlateNumberModificationView_Previews: PreviewProvider {
    static var previews: some View {
        PlateNumberModificationView()
    }
}
