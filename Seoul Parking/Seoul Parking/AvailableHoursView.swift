//
//  AvailableHoursView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 8/7/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct AvailableHoursView: View {
    @Environment(\.showParkingSpaceInfoView) var showParkingSpaceInfoView
    @Environment(\.selectedParkingSpace) var selectedParkingSpace
    
    init() {
        UITableView.appearance().backgroundColor = .white
        
        UITableViewCell.appearance().backgroundColor = .white
    }
    
    var body: some View {
        ZStack{
            Color.white
            
            self.AvailableTime
        }
        
    }
    
    private var AvailableTime: some View {
        if let timeSlots = self.selectedParkingSpace?.wrappedValue.availableTime {
            
           
            
            
            var availableTime = [Time]()
            
            for (index, elem) in timeSlots.enumerated() {
                
                for(i, availability) in elem.enumerated(){
                    
                    var minute = "00"
                    var isAvailable = false
                    
                    if i == 0{
                        minute = "00"
                    }else {
                        minute = "30"
                    }
                    
                    if availability == 0 {
                        isAvailable = false
                    } else if availability == 1 {
                        isAvailable = true
                    }
                    
                    availableTime.append(Time(hour: index, minute: minute, isAvailable: isAvailable))
                }
                
                
            }
            
            
            return AnyView(
                
                List(0..<availableTime.endIndex){index in
                    
                
                    AvailableTimeRow(time: availableTime[index])
                }
            )
        }else {
            return AnyView(
                EmptyView()
            )

        }
        
    }
}

struct AvailableHoursView_Previews: PreviewProvider {
    static var previews: some View {
        AvailableHoursView()
    }
}

struct AvailableTimeRow: View {
    var time : Time
    @State var showAlert = false
    var body: some View{
        var timeString = ""
        
        if time.minute == "00" {
            timeString = String(format:"%02d:00 ~ %02d:29", time.hour, time.hour)
        }else {
            timeString = String(format:"%02d:30 ~ %02d:59", time.hour, time.hour)
        }
        
        
        var statusString = ""
        
        if time.isAvailable {
            statusString = "입차 가능"
        } else {
            statusString = "입차 불가"
        }
        
        
        return HStack{
            Text(timeString)
                .foregroundColor(Color.black)
                .frame(width: 150)
            
            self.StatusImage
            
            Text(statusString)
                .foregroundColor(Color.black)
                .frame(width: 100)
        }
        .onTapGesture {
            self.showAlert = true
        }
        .alert(isPresented: self.$showAlert){
            Alert(title: Text( "예약하기"), message: Text( "예약하시겠습니까?" ), primaryButton: .cancel(Text("취소"), action: {self.showAlert = false}), secondaryButton: .default(Text("예약"), action: {}))
        }
    }
    
    private var StatusImage: some View {

        
        if time.isAvailable {
            return AnyView( Image(systemName: "checkmark.circle.fill")
                .frame(width: 30, height: 30)
                .foregroundColor(Color.green)
                .background(Color.white)
                .clipShape(Circle())
                .padding(.leading, 10)
            )
        }else {
            return AnyView( Image(systemName: "xmark.circle.fill")
                .frame(width: 30, height: 30)
                .foregroundColor(Color.gray)
                .background(Color.white)
                .clipShape(Circle())
                .padding(.leading, 10)
            )
        }
        
        
    }
}

struct Time {
    var hour: Int
    var minute: String
    var isAvailable: Bool
    
    init(hour: Int, minute: String, isAvailable: Bool) {
        self.hour = hour
        self.minute = minute
        self.isAvailable = isAvailable
    }
}
