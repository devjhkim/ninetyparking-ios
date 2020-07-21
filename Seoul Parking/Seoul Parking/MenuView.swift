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
    
    var body: some View {
        
        GeometryReader{ proxy in
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "person")
                        .imageScale(.large)
                        .foregroundColor(.gray)
                    Text(self.loginText)
                        .foregroundColor(.gray)
                        .font(.headline)
                    
                    

                }
                .padding(.top, 100)
                .onTapGesture(perform: {
                    self.showLonginView = true
                })
                .sheet(isPresented: self.$showLonginView){
                    LoginView()
                }
                
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                    Text("Profile")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
                .padding(.top, 30)
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
                .background(Color(red: 32/255, green: 32/255, blue: 32/255))
                .edgesIgnoringSafeArea(.all)
        }
        
        
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
