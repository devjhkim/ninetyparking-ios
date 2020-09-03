//
//  PlateNumberView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 2020/09/03.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct PlateNumberView: View {
    @State var plateNumbers = [String]()
    @State var plateNumber = ""
    @State var showPlateNumberMaxAlert = false
    
    init() {
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        ZStack{
            Color.white
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            VStack(alignment: .leading){
                Text("차량번호 등록")
                    .bold()
                    .font(.system(size: 40))
                    .padding(.bottom, 20)
                    .padding(.leading, 10)
                    
                
                HStack{
                    TextField("차량번호", text: self.$plateNumber)
                        .font(.system(size: 30))
                    
                    
                    Button(action: {
                        if !self.plateNumber.isEmpty {
                            if self.plateNumbers.count < MAX_PLATE_NUMBERS {
                                if !self.plateNumbers.contains(self.plateNumber){
                                    self.plateNumbers.append(self.plateNumber)
                                }
                            } else {
                                self.showPlateNumberMaxAlert = true
                            }
                            
                        }
                    }){
                        Image(systemName: "plus")
                            .renderingMode(.template)
                            .foregroundColor(Color.gray)
                            .imageScale(.large)
                            .padding()

                    }
                    
                    
                    
                }
                .padding()
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
                                Image(systemName: "xmark.circle.fill")
                                    .renderingMode(.template)
                                    .foregroundColor(Color.gray)
                                    .imageScale(.large)
                                    .padding()
                            }
                        }

                    }
                    .onDelete(perform: delete(at:))
                
                }
                
                Spacer()

            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        self.plateNumbers.remove(atOffsets: offsets)
    }
    
}

struct PlateNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PlateNumberView()
    }
}
