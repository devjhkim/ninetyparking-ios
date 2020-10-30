//
//  ParkingSpaceInfoView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 8/6/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct ParkingSpaceInfoView: View {
    @Environment(\.showParkingSpaceInfoView) var showParkingSpaceInfoView
    @Environment(\.selectedParkingSpace) var selectedParkingSpace
    @Environment(\.showAvailableTimeView) var showAvailableTimeView
     
    @State var showNavigationSelectionModal = false
    
    var body: some View {
        
        ZStack{
            GeometryReader(){ proxy in
                EmptyView()
                    
                    
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.5))
            .edgesIgnoringSafeArea(.all)
            
            
            .onTapGesture {
                
                self.showParkingSpaceInfoView?.wrappedValue = false
            }
            
            
            VStack{
                Spacer()
                
                GeometryReader() { proxy in
                    
                    HStack{
                        Spacer()
                        
                        VStack{
                            
                            Spacer()
                            
                            VStack(alignment: .leading){
                                Spacer()
                                
                                HStack{
                                    self.Address
                                    
                                    Spacer()
                                    
                                    Button(action: {self.showNavigationSelectionModal.toggle()}){
                                        Image("navigationButton")
                                    }
                                    .padding(.trailing, 20)
                                }
                                .padding([.top], 10)
                                .padding(.leading, 20)
                                
                                
                                self.Price
                                    .padding([.top], 10)
                                    .padding(.leading, 20)
                                self.OpenHours
                                    .padding([.top], 10)
                                    .padding(.leading, 20)
                                self.Buttons
                                    .padding([.top, .leading, .bottom], 20)
                                Spacer()
                                
                            }
                            .background(Color.white)
                            .frame(height: 200)
                            .frame(width: proxy.size.width * 0.9, alignment: .leading)
                            .cornerRadius(20)
                            .padding( 20)
                            
                            
                            
                            
                        }
                        Spacer()
                    }
                    
                    
                    
                }

                
            }
        }
        
        
        
    }
    
    private var Address: some View {
        if let address = self.selectedParkingSpace?.wrappedValue.address {
            return AnyView(
                Text(address)
                    .foregroundColor(Color.black)
                    .font(.system(size: 15, weight: .bold))
                    
                    
            )
        }else{
            return AnyView(Text(""))
        }
    }
    
    private var Price: some View {
        if let unitPrice = self.selectedParkingSpace?.wrappedValue.chargePerTenMinute {
            return AnyView(
                
                Text("가격: (10분당) " + unitPrice + "원")
                    .foregroundColor(Color.black)
                    
                    
            )
        }else{
            return AnyView(EmptyView())
        }
    }
    
    private var OpenHours: some View {
        return AnyView(
            Text("운영시간: 00시 ~ 23시")
                .foregroundColor(Color.black)
        )
    }
    
    private var Buttons: some View {
        return AnyView(
            HStack{
                Spacer()
                
                Button(action:{self.showParkingSpaceInfoView?.wrappedValue = false}){
                    Image("closeButton")

                }

                Spacer()
                
                Button(action:{
                    self.showParkingSpaceInfoView?.wrappedValue = false
                    self.showAvailableTimeView?.wrappedValue = true
                }){
                    
                    Image("timeCheckButton")

                }
               
                
                
                
                
                Spacer()
            }
        )
    }
}

struct ParkingSpaceInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ParkingSpaceInfoView()
    }
}

