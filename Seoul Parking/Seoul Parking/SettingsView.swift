//
//  SettingsView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 2020/09/12.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var store: Store
    
    
    var body: some View {
        ZStack{
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack{
                NavigationLink(destination:NameModificationView()){
                    HStack{
                        Text("이름")
                            .foregroundColor(.black)
                        Spacer()
                        Text(self.store.user.name)
                            .foregroundColor(.gray)
                        Image(systemName: "arrow.right.circle")
                            .renderingMode(.template)
                            .foregroundColor(Color.gray)
                            .imageScale(.large)
                        
                    }
                    .padding()
                }
                
                NavigationLink(destination: PlateNumberModificationView()){
                    
                    HStack{
                        Text("차량번호")
                            .foregroundColor(.black)
                        Spacer()
                        PlateNumberText
                            .foregroundColor(.gray)
                        Image(systemName: "arrow.right.circle")
                            .renderingMode(.template)
                            .foregroundColor(Color.gray)
                            .imageScale(.large)
                    }
                    .padding()
                    
                }
                
                NavigationLink(destination:EmailModificationView()){
                    HStack{
                        Text("이메일")
                            .foregroundColor(.black)
                        Spacer()
                        Text(self.store.user.email)
                            .foregroundColor(.gray)
                        Image(systemName: "arrow.right.circle")
                            .renderingMode(.template)
                            .foregroundColor(Color.gray)
                            .imageScale(.large)
                    }
                    .padding()
                }
                
                
                NavigationLink(destination: PasswordModificationView()){
                    HStack{
                        Text("비밀번호 변경")
                            .foregroundColor(.black)
                        Spacer()
                        
                        Image(systemName: "arrow.right.circle")
                            .renderingMode(.template)
                            .foregroundColor(Color.gray)
                            .imageScale(.large)
                    }
                    .padding()

                }
                
                Spacer()
                
            }
            
            
        }
        
    }
    
    private var PlateNumberText: some View {
        var plateNumber = ""
        
        if self.store.user.plateNumbers.count > 0 {
            plateNumber = self.store.user.plateNumbers[0]
        }
        
        return AnyView(
            Text(plateNumber)
        )
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
