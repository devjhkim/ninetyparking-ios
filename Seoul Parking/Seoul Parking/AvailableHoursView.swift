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
    var body: some View {
        ZStack{
            Color.white
            
            self.AvailableTime
        }
    }
    
    private var AvailableTime: some View {
        if let timeSlots = self.selectedParkingSpace?.wrappedValue.availableTime {
            return AnyView(
                ForEach(timeSlots, id: \.self){ slot in
                    
                    Text(slot.description )
                        .foregroundColor(Color.black)
                    
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
