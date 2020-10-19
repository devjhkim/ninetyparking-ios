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
    
    var body: some View {
        ZStack{
            GeometryReader(){ reader in
                EmptyView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color.gray.opacity(0.3))
            
            ZStack{
                Color.white
                    .frame(width: 300, height: 200, alignment: Alignment.center)
                
                VStack{
                    Text("비밀번호 확인")
                        .bold()
                        .font(.system(size: 18))
                        .padding()
                    
                    Text("본인확인을 위해 비밀번호를 입력해야 합니다.")
                        .padding()

                    
                    TextField("비밀번호", text:self.$password)
                        .padding()
                    
                    HStack{
                        Button(action: {self.auxViewType.showPasswordCheckAlert = false}){
                            Text("취소")
                                .foregroundColor(Color.red)
                        }
                        
                        Button(action: {self.auxViewType.showPasswordCheckAlert = false}){
                            Text("확인")
                                .foregroundColor(Color.blue)
                        }
                    }
                    
                    
                    
                }
                .frame(width: 250, height: 180, alignment: Alignment.center)
                
            }
            
        }
        
    }
}

struct PasswordCheckView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordCheckView(auxViewType: .constant(AuxViewType()))
    }
}
