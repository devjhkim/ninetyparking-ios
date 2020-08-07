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
    
    var body: some View {
        
        ZStack{
            GeometryReader(){ proxy in
                EmptyView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color.gray.opacity(0.5))
            
            
            .onTapGesture {
                print("Tap tap")
                self.showParkingSpaceInfoView?.wrappedValue = false
            }
            
            
            VStack{
                Spacer()
                
                GeometryReader() { proxy in
                    VStack{
                        
                        
                        VStack(alignment: .leading){
                            
                            self.Address
                                .padding([.top, .leading], 10)
                            self.Price
                                .padding([.top, .leading], 10)
                            self.OpenHours
                                .padding([.top, .leading], 10)
                            self.Buttons
                                .padding(.top, 20)
                            Spacer()
                            
                        }
                        .frame(height: 180)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                    }
                    
                    
                }
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth:.infinity)
                .frame(height: 200)
                
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
        if let unitPrice = self.selectedParkingSpace?.wrappedValue.info {
            return AnyView(
                
                Text("가격: (30분당) " + unitPrice + "원")
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
                    Text("닫기")
                    .fontWeight(.bold)
                    .font(.system(size: 15))
                    .foregroundColor(.red)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.red, lineWidth: 2)
                    )
                }
                    
                
                
                
                Spacer()
                
                Button(action:{
                    self.showAvailableTimeView?.wrappedValue = true
                }){
                    Text("예약하기")
                        
                    .fontWeight(.bold)
                    .font(.system(size: 15))
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    
                    .cornerRadius(20)
                    
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
