//
//  MenuView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 7/10/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI
import Combine

struct MenuView: View {
    
    @State var loginText = "로그인"
    @State var showLonginView = false
    
    @Binding var showMenu : Bool
    @Binding var auxLoginView: AuxLoginViewType
    
    var body: some View {
        
        GeometryReader{ proxy in
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "person")
                        .imageScale(.large)
                        .foregroundColor(.gray)
                    
                    if UserInfo.getInstance.isLoggedIn {
                        HStack{
                            Text(UserInfo.getInstance.name)
                                .foregroundColor(Color.gray)
                                .font(.headline)
                            
                            Text("로그아웃")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 10))
                                .underline()
                                
                            
                        }
                        
                    } else {
                        Text("로그인 하세요")
                        .foregroundColor(.gray)
                        .font(.headline)
                    }
                    
                    
                    
                    

                }
                .padding(.top, 100)
                .onTapGesture(perform: {
                    
                    self.showLonginView = false
                    self.auxLoginView.showLoginView = true
                    
                })
                .sheet(isPresented: self.$showLonginView){
                    LoginView()
                }
                
               
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Messages")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
                    .padding(.top, 30)
                HStack {
                    Image(systemName: "gear")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Settings")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
                .padding(.top, 30)
                .gesture(TapGesture()
                    .onEnded{ _ in
                        print("Settings tapped")
                })
                Spacer()
            }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
        }
        
        
    }

}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(showMenu: .constant(false), auxLoginView: .constant(AuxLoginViewType()))
    }
}
