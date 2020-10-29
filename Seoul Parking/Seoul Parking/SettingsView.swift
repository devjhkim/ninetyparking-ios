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
    @State var radius: Double = 1.0
    @Binding var auxViewType: AuxViewType
    
    var body: some View {
        
        
        
        ZStack{
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack{
                
                HStack{
                    Text("검색반경")
                        .foregroundColor(Color.black)
                    
                    Slider(value: self.$radius, in: 1...5, step: 1)
                        .padding(.leading, 5)
                        .onChange(of: self.radius, perform: {_ in
                            UserDefaults.standard.setValue(self.radius, forKey: "searchRadius")
                            self.store.searchRadius = Int(self.radius)
                        })
                        .onAppear(){
                            self.radius = Double(self.store.searchRadius)
                        }
                    
                    Text(String(format: "%dkm", Int(self.radius)))
                        .foregroundColor(Color.black)
                        .padding(.leading, 5)
                    
                }
                .padding()
                
                VStack{
                    HStack{
                        Text("버튼 보이기/숨기기")
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                    
                    HStack{
                        
                        Toggle(isOn: self.$auxViewType.showAnnoucementsButton){
                            Text("공지사항")
                                .foregroundColor(Color.black)

                        }
                        .onChange(of: self.auxViewType.showAnnoucementsButton, perform: {_ in
                            UserDefaults.standard.setValue(self.auxViewType.showAnnoucementsButton, forKey: "showAnnouncementsButton")
                        })
                    }
                    
                    HStack{
                        
                        Toggle(isOn: self.$auxViewType.showPaymentHistoryButtons){
                            Text("결제/미결제 내역")
                                .foregroundColor(Color.black)

                        }
                        .onChange(of: self.auxViewType.showPaymentHistoryButtons){_ in
                            UserDefaults.standard.setValue(self.auxViewType.showPaymentHistoryButtons, forKey: "showPaymentHistoryButtons")
                        }
                    }
                }
                .padding()
                .padding(.top, 20)
                
                Spacer()
                
            }
            .navigationTitle(Text("설정"))
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
        SettingsView(auxViewType: .constant(AuxViewType()))
    }
}
