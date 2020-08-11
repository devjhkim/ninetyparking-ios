//
//  ReservationView.swift
//  Seoul Parking
//
//  Created by Chiduk Song on 8/10/20.
//  Copyright © 2020 Chiduk Studio. All rights reserved.
//

import SwiftUI

struct ReservationView: View {
    var body: some View {
        ZStack{
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            Rectangle()
                .fill(Color.blue)
                .frame(width: 270, height: 250)
                
                
            
        }
        .background(Color.white)
        
    }
    

}

struct ReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationView()
    }
}
