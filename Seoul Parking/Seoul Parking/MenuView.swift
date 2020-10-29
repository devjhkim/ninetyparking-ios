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
    @EnvironmentObject var login: LogIn
    @State var loginText = "로그인"
    
    
    @Binding var showMenu : Bool
    @Binding var auxView: AuxViewType
    
    @State var size: CGSize = .zero
    @State var isLoggedIn = false
    
    @Environment(\.showLoginView) var showLoginView
    
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
                        
                        if self.login.isLoggedIn {
                            HStack{
                                Text(UserInfo.getInstance.name)
                                    .foregroundColor(Color.gray)
                                    .font(.headline)
                                    .onTapGesture {
                                        self.auxView.showPasswordCheckAlert = true
                                        
                                    }
                                
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
                                    
                                    
                                    self.showLoginView?.wrappedValue = true
                                    self.showMenu = false
                                    
                                })
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    
                    
                    HStack {
                        Image(systemName: "wonsign.circle")
                            .foregroundColor(.gray)
                            .imageScale(.large)
                        Text("결제내역")
                            .foregroundColor(.gray)
                            .font(.headline)
                        
                        Spacer()
                    }
                    .padding(.top, 30)
                    .onTapGesture {
                        self.auxView.showPaymentHistoryView = true
                    }
                    
                    
                    HStack {
                        Image(systemName: "wonsign.square")
                            .foregroundColor(.gray)
                            .imageScale(.large)
                        Text("미결제내역")
                            .foregroundColor(.gray)
                            .font(.headline)
                        
                        Spacer()
                    }
                    .padding(.top, 30)
                    .onTapGesture {
                        self.auxView.showUnpaidPaymentHistoryView = true
                    }
                    
                    HStack {
                        Image(systemName: "gearshape")
                            .foregroundColor(.gray)
                            .imageScale(.large)
                        Text("환경설정")
                            .foregroundColor(.gray)
                            .font(.headline)
                        
                        Spacer()
                    }
                    .padding(.top, 30)
                    .onTapGesture {
                        self.auxView.showSettingsView = true
                    }
                    
                    HStack {
                        Image(systemName: "newspaper")
                            .foregroundColor(.gray)
                            .imageScale(.large)
                        Text("공지사항")
                            .foregroundColor(.gray)
                            .font(.headline)
                        
                        Spacer()
                    }
                    .padding(.top, 30)
                    .onTapGesture {
                        self.auxView.showAnnouncementsView = true
                    }
                    
                    Spacer()
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
        self.login.isLoggedIn = false
    }
    
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(showMenu: .constant(false), auxView: .constant(AuxViewType()))
    }
}


//struct MenuContent: View {
//    var body: some View {
//
//
//        List{
//            HStack {
//                Image(systemName: "person")
//                    .imageScale(.large)
//                    .foregroundColor(.gray)
//
//                if UserInfo.getInstance.isLoggedIn {
//                    HStack{
//                        Text(UserInfo.getInstance.name)
//                            .foregroundColor(Color.gray)
//                            .font(.headline)
//
//                        Text("로그아웃")
//                            .foregroundColor(Color.gray)
//                            .font(.system(size: 10))
//                            .underline()
//                            .onTapGesture {
//                                //self.logout()
//                        }
//
//
//                    }
//
//                } else {
//                    Text("로그인 하세요")
//                        .foregroundColor(.gray)
//                        .font(.headline)
//                        .onTapGesture(perform: {
//
//                            //                         self.showLonginView = false
//                            //                         self.auxLoginView.showLoginView = true
//                            //                         self.showMenu = false
//
//                        })
//                }
//
//
//
//
//
//            }
//            .padding(.top, 100)
//
//            //             .sheet(isPresented: self.$showLonginView){
//            //                 LoginView()
//            //             }
//            //
//
//            HStack {
//                Image(systemName: "envelope")
//                    .foregroundColor(.gray)
//                    .imageScale(.large)
//                Text("Messages")
//                    .foregroundColor(.gray)
//                    .font(.headline)
//            }
//            .padding(.top, 30)
//            HStack {
//                Image(systemName: "gear")
//                    .foregroundColor(.gray)
//                    .imageScale(.large)
//                Text("Settings")
//                    .foregroundColor(.gray)
//                    .font(.headline)
//            }
//            .padding(.top, 30)
//            .gesture(TapGesture()
//            .onEnded{ _ in
//                print("Settings tapped")
//            })
//        }
//    }
//}
