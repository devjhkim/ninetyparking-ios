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
            
  
            
            print(timeSlots.count)
            return AnyView(
                
                List(0..<timeSlots.endIndex){index in
                    AvailableTimeRow(time: timeSlots[index].description)
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
    var time : String
    
    var body: some View{
        Text(time)
            .foregroundColor(Color.black)
            
            
    }
}
