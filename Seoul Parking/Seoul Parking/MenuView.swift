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
    @State var width: CGFloat = 0
    @State var size: CGSize = .zero
    @State var isLoggedIn = false
    
    
    
    var body: some View {
        ZStack {
            GeometryReader{ proxy in
                EmptyView()
                .frame(maxWidth:.infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            }
            
            .background(Color.gray.opacity(0.3))
            .opacity(self.showMenu ? 1.0 : 0.0)
            .animation(Animation.easeIn.delay(0.25))
            .onTapGesture {
                self.showMenu = false
            }
            
            HStack{
                VStack(alignment: .leading){
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
                                    .onTapGesture {
                                        self.logout()
                                }
                            }
                            
                            
                        } else {
                            Text("로그인 하세요")
                                .foregroundColor(.gray)
                                .font(.headline)
                                .onTapGesture(perform: {
                                    
                                    self.showLonginView = false
                                    self.auxLoginView.showLoginView = true
                                    self.showMenu = false
                                    
                                })
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 100)
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
                        
                        Spacer()
                    }
                    .padding(.top, 30)
                    
                    HStack {
                        Image(systemName: "gear")
                            .foregroundColor(.gray)
                            .imageScale(.large)
                        Text("Settings")
                            .foregroundColor(.gray)
                            .font(.headline)
                        
                        Spacer()
                    }
                    .padding(.top, 30)
                    .gesture(TapGesture()
                    .onEnded{ _ in
                        print("Settings tapped")
                    })
                    
                    Spacer()
                }
                    .padding()
                    .frame(width: self.size.width)
                    .frame(maxHeight: .infinity)
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.all)
                    .offset(x: self.showMenu ? 0 : -self.size.width )
                    .animation(.default)
                
                Spacer()
            }
        }
        .onAppear(perform: {
            self.isLoggedIn = UserInfo.getInstance.isLoggedIn
        })
        
        
    }
    
    func logout() {
        handleLogout()
        self.isLoggedIn = false
    }
    
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(showMenu: .constant(false), auxLoginView: .constant(AuxLoginViewType()), width: 0)
    }
}


struct MenuContent: View {
    var body: some View {
        
        
        List{
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
                            .onTapGesture {
                                //self.logout()
                        }
                        
                        
                    }
                    
                } else {
                    Text("로그인 하세요")
                        .foregroundColor(.gray)
                        .font(.headline)
                        .onTapGesture(perform: {
                            
                            //                         self.showLonginView = false
                            //                         self.auxLoginView.showLoginView = true
                            //                         self.showMenu = false
                            
                        })
                }
                
                
                
                
                
            }
            .padding(.top, 100)
            
            //             .sheet(isPresented: self.$showLonginView){
            //                 LoginView()
            //             }
            //
            
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
        }
    }
}
